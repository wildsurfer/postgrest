{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TupleSections #-}
--module PostgREST.App where
module PostgREST.App (
  app
) where

import           Network.HTTP.Types.Status
import           Network.Wai

import qualified Hasql.Session             as H

import           PostgREST.Config          (AppConfig (..))
import           PostgREST.Types

import           PostgREST.QueryBuilder ( lockRowExclusive )

import           Prelude

app :: DbStructure -> AppConfig -> RequestBody -> Request -> H.Session Response
app _ _ _ _ = do
  lockRowExclusive $ QualifiedIdentifier "public" "film"
  return $ responseLBS status200 [] ""
