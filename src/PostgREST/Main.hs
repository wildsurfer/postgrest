{-# LANGUAGE CPP #-}

module Main where


import           PostgREST.App
import           PostgREST.Config                     (AppConfig (..),
                                                       minimumPgVersion,
                                                       prettyVersion,
                                                       readOptions)
import           PostgREST.DbStructure
import           PostgREST.Error                      (errResponse, pgErrResponse)

import           Control.Monad                        (unless, void, forever)
import           Data.Monoid                          ((<>))
import           Data.Pool
import           Data.String.Conversions              (cs)
import qualified Hasql.Query                          as H
import qualified Hasql.Connection                     as H
import qualified Hasql.Session                        as H
import qualified Hasql.Decoders                       as HD
import qualified Hasql.Encoders                       as HE
import qualified Network.HTTP.Types.Status            as HT
import           Network.Wai.Handler.Warp
import           System.IO                            (BufferMode (..),
                                                       hSetBuffering, stderr,
                                                       stdin, stdout)
import           Web.JWT                              (secret)

#ifndef mingw32_HOST_OS
import           System.Posix.Signals
import           Control.Concurrent                   (myThreadId, forkIO, threadDelay)
import           Control.Exception.Base               (throwTo, AsyncException(..))
#endif

import Data.Time.Clock.POSIX
import System.Random (getStdRandom, randomR)

isServerVersionSupported :: H.Session Bool
isServerVersionSupported = do
  ver <- H.query () pgVersion
  return $ read (cs ver) >= minimumPgVersion
 where
  pgVersion =
    H.statement "SHOW server_version_num"
      HE.unit (HD.singleRow $ HD.value HD.text) True

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  hSetBuffering stdin  LineBuffering
  hSetBuffering stderr NoBuffering

  conf <- readOptions
  let port = configPort conf

  unless (secret "secret" /= configJwtSecret conf) $
    putStrLn "WARNING, running in insecure mode, JWT secret is the default value"
  Prelude.putStrLn $ "Listening on port " ++
    (show $ configPort conf :: String)

  let pgSettings = cs (configDatabase conf)
      appSettings = setPort port
                  . setServerName (cs $ "postgrest/" <> prettyVersion)
                  $ defaultSettings

  void . forkIO . forever $ do
    t <- round <$> getPOSIXTime :: IO Integer
    putStrLn $ "alive " ++ show t
    threadDelay 1000000

  pool <- createPool (H.acquire pgSettings)
            (either (const $ return ()) H.release) 1 1 (configPool conf)

  dbStructure <- withResource pool $ \case
    Left err -> error $ show err
    Right c -> do
      supported <- H.run isServerVersionSupported c
      case supported of
        Left e -> error $ show e
        Right good -> unless good $
          error (
            "Cannot run in this PostgreSQL version, PostgREST needs at least "
            <> show minimumPgVersion)

      dbOrError <- H.run (getDbStructure (cs $ configSchema conf)) c
      either (error . show) return dbOrError

#ifndef mingw32_HOST_OS
  tid <- myThreadId
  void $ installHandler keyboardSignal (Catch $ do
      putStrLn "Attempting to empty pool..."
      destroyAllResources pool
      throwTo tid UserInterrupt
    ) Nothing
#endif

  runSettings appSettings $ \ req respond -> do
    threadDelay =<< getStdRandom (randomR (0,1000000))
    let handleReq = H.run $
          (app dbStructure conf "") req
    withResource pool $ \case
      Left err -> respond $ errResponse HT.status500 (cs . show $ err)
      Right c -> do
        resOrError <- handleReq c
        either (respond . pgErrResponse) respond resOrError
