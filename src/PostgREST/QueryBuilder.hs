{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TupleSections        #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
{-|
Module      : PostgREST.QueryBuilder
Description : PostgREST SQL generating functions.

This module provides functions to consume data types that
represent database objects (e.g. Relation, Schema, SqlQuery)
and produces SQL Statements.

Any function that outputs a SQL fragment should be in this module.
-}
module PostgREST.QueryBuilder (
    addRelations
  , addJoinConditions
  , asJson
  , callProc
  , createReadStatement
  , createWriteStatement
  , operators
  , pgFmtIdent
  , pgFmtLit
  , requestToQuery
  , requestToCountQuery
  , sourceCTEName
  , unquoted
  ) where

import qualified Hasql.Query                   as H
import qualified Hasql.Encoders                as HE
import qualified Hasql.Decoders                as HD

import qualified Data.Aeson                    as JSON
import           Data.Int

import           Control.Applicative           (empty, (<|>))
import           Control.Error                 (fromMaybe, mapMaybe, note)
import           Control.Monad                 (join)
import qualified Data.ByteString.Char8         as BS
import qualified Data.HashMap.Strict           as HM
import           Data.List                     (find, (\\))
import qualified Data.Map                      as M
import           Data.Monoid                   ((<>))
import           Data.Scientific               (FPFormat (..), formatScientific,
                                                isInteger)
import           Data.String.Conversions       (cs)
import           Data.Text                     (Text, isInfixOf, replace, split,
                                                toLower, unwords)
import qualified Data.Text                     as T (map, takeWhile)
import           Data.Tree                     (Tree (..))
import qualified Data.Vector                   as V
import           PostgREST.ApiRequest          (PreferRepresentation (..))
import           PostgREST.RangeQuery          (NonnegRange, rangeLimit,
                                                rangeOffset)
import           PostgREST.Types
import           Prelude                       hiding (unwords)
import           Text.InterpolatedString.Perl6 (qc)
import           Text.Regex.TDFA               ((=~))

type Escaped = BS.ByteString

pgFmtIdent :: BS.ByteString -> Escaped
pgFmtIdent x = "\"" <> replace "\"" "\"\"" (trimNullChars $ cs x) <> "\""

pgFmtLit :: SqlFragment -> Escaped
pgFmtLit x =
 let trimmed = trimNullChars x
     escaped = "'" <> replace "'" "''" trimmed <> "'"
     slashed = replace "\\" "\\\\" escaped in
 if "\\\\" `isInfixOf` escaped
   then "E" <> slashed
   else slashed

createReadStatement :: SqlFragment -> SqlFragment ->
                       NonnegRange -> Bool -> Bool -> Bool ->
                       (H.Query ()
                        (Maybe Int64, Int64, Maybe BS.ByteString, JSON.Value))
createReadStatement selectQuery countQuery range isSingle countTotal asCsv =
  "WITH " <> sourceCTEName <> " AS (" <> selectQuery <> ") " <>
  "SELECT " <> BS.intercalate ", " [
    countResultF <> " AS total_result_set",
    "pg_catalog.count(t) AS page_total",
    "null AS header",
    bodyF <> " AS body"
  ] <>
  " FROM ( SELECT * FROM " <> sourceCTEName <> " " <> limitF range <> ") t"
 where
  countResultF = if countTotal then "("<>countQuery<>")" else "null"
  bodyF
    | asCsv = asCsvF
    | isSingle = asJsonSingleF
    | otherwise = asJsonF

createWriteStatement :: QualifiedIdentifier -> SqlFragment -> SqlFragment ->
                        Bool -> PreferRepresentation -> [Text] ->
                        Bool -> Payload ->
                        (H.Query ()
                         (Maybe Int64, Int64, Maybe BS.ByteString, JSON.Value))
createWriteStatement _ _ _ _ _ _ _ (PayloadParseError _) = undefined
createWriteStatement _ _ mutateQuery _ None
                     _ _ (PayloadJSON (UniformObjects rows)) =
  "WITH " <> sourceCTEName <> " AS (" <> mutateQuery <> ") " <>
  "SELECT null, 0, null, null"
  -- ((H.value H.json) . JSON.Array . V.map JSON.Object $ rows)
createWriteStatement qi _ mutateQuery isSingle HeadersOnly
                     pKeys _ (PayloadJSON (UniformObjects rows)) =
  (
    "WITH " <> sourceCTEName <> " AS (" <> mutateQuery <> " RETURNING " <> fromQi qi <> ".*" <> ") " <>
    "SELECT " <> BS.intercalate ", " [
      "null AS total_result_set",
      "pg_catalog.count(t) AS page_total",
      if isSingle then locationF pKeys else "null",
      "null"
    ] <>
    " FROM (SELECT 1 FROM " <> sourceCTEName <> ") t"
  , (V.singleton . JSON.Array . V.map JSON.Object $ rows)
  )
createWriteStatement qi selectQuery mutateQuery isSingle Full
                     pKeys asCsv (PayloadJSON (UniformObjects rows)) =
  (
    "WITH " <> sourceCTEName <> " AS (" <> mutateQuery <> " RETURNING " <> fromQi qi <> ".*" <> ") " <>
    "SELECT " <> BS.intercalate ", " [
      "null AS total_result_set", -- when updateing it does not make sense
      "pg_catalog.count(t) AS page_total",
      if isSingle then locationF pKeys else "null" <> " AS header",
      bodyF <> " AS body"
    ] <>
    " FROM ( "<>selectQuery<>") t"
  , (V.singleton . JSON.Array . V.map JSON.Object $ rows)
  )
  where
    bodyF
      | asCsv = asCsvF
      | isSingle = asJsonSingleF
      | otherwise = asJsonF

addRelations :: Schema -> [Relation] -> Maybe ReadRequest -> ReadRequest -> Either Text ReadRequest
addRelations schema allRelations parentNode node@(Node readNode@(query, (name, _)) forest) =
  case parentNode of
    (Just (Node (Select{from=[parentTable]}, (_, _)) _)) -> Node <$> (addRel readNode <$> rel) <*> updatedForest
      where
        rel = note ("no relation between " <> parentTable <> " and " <> name)
            $  findRelationByTable schema name parentTable
           <|> findRelationByColumn schema parentTable name
        addRel :: (ReadQuery, (NodeName, Maybe Relation)) -> Relation -> (ReadQuery, (NodeName, Maybe Relation))
        addRel (q, (n, _)) r = (q {from=fromRelation}, (n, Just r))
          where fromRelation = map (\t -> if t == n then tableName (relTable r) else t) (from q)

    _ -> Node (query, (name, Nothing)) <$> updatedForest
  where
    updatedForest = mapM (addRelations schema allRelations (Just node)) forest
    -- Searches through all the relations and returns a match given the parameter conditions.
    -- Will only find a relation where both schemas are in the PostgREST schema.
    -- `findRelationByColumn` also does a ducktype check to see if the column name has any variation of `id` or `fk`. If so then the relation is returned as a match.
    findRelationByTable s t1 t2 =
      find (\r -> s == tableSchema (relTable r) && s == tableSchema (relFTable r) && t1 == tableName (relTable r) && t2 == tableName (relFTable r)) allRelations
    findRelationByColumn s t c =
      find (\r -> s == tableSchema (relTable r) && s == tableSchema (relFTable r) && t == tableName (relFTable r) && length (relFColumns r) == 1 && c `colMatches` (colName . head . relFColumns) r) allRelations
      where n `colMatches` rc = (cs ("^" <> rc <> "_?(?:|[iI][dD]|[fF][kK])$") :: BS.ByteString) =~ (cs n :: BS.ByteString)

addJoinConditions :: Schema -> ReadRequest -> Either Text ReadRequest
addJoinConditions schema (Node (query, (n, r)) forest) =
  case r of
    Nothing -> Node (updatedQuery, (n,r))  <$> updatedForest -- this is the root node
    Just rel@(Relation{relType=Child}) -> Node (addCond updatedQuery (getJoinConditions rel),(n,r)) <$> updatedForest
    Just (Relation{relType=Parent}) -> Node (updatedQuery, (n,r)) <$> updatedForest
    Just rel@(Relation{relType=Many, relLTable=(Just linkTable)}) ->
      Node (qq, (n, r)) <$> updatedForest
      where
         q = addCond updatedQuery (getJoinConditions rel)
         qq = q{from=tableName linkTable : from q}
    _ -> Left "unknown relation"
  where
    -- add parentTable and parentJoinConditions to the query
    updatedQuery = foldr (flip addCond) query parentJoinConditions
      where
        parentJoinConditions = map (getJoinConditions . snd) parents
        parents = mapMaybe (getParents . rootLabel) forest
        getParents (_, (tbl, Just rel@(Relation{relType=Parent}))) = Just (tbl, rel)
        getParents _ = Nothing
    updatedForest = mapM (addJoinConditions schema) forest
    addCond q con = q{flt_=con ++ flt_ q}

asJson :: H.Query a b -> H.Query a JSON.Value
asJson (H.Query sql param result) = H.Query
    (prefix <> sql <> suffix) param
    (HD.singleRow (HD.value HD.json))
 where
  prefix = "array_to_json(coalesce(array_agg(row_to_json(t)), '{}'))::character varying from ("
  suffix = ") t"

callProc :: QualifiedIdentifier -> H.Query JSON.Value JSON.Value
callProc qi params = H.Query
    ("select * from " <> fromQi qi <> "(" <> args <> ")")
    (HE.value HE.json) (HD.singleRow (HD.value HD.json))
 where
  args = BS.intercalate "," $ map assignment (HM.toList params)
  assignment (n,v) = pgFmtIdent n <> ":=" <> insertableValue v

operators :: [(Text, SqlFragment)]
operators = [
  ("eq", "="),
  ("gte", ">="), -- has to be before gt (parsers)
  ("gt", ">"),
  ("lte", "<="), -- has to be before lt (parsers)
  ("lt", "<"),
  ("neq", "<>"),
  ("like", "like"),
  ("ilike", "ilike"),
  ("in", "in"),
  ("notin", "not in"),
  ("isnot", "is not"), -- has to be before is (parsers)
  ("is", "is"),
  ("@@", "@@"),
  ("@>", "@>"),
  ("<@", "<@")
  ]

-- | Unspecified decoder because this will be
-- transofmred into another kind of Query
select :: [Escaped] -> [Escaped] -> H.Query () ()
select cols tables =
  H.Query sql HE.unit HD.unit True
 where
  selection = BS.intercalate "," cols
  from = BS.intercalate "," tables
  sql = [qc|
      SELECT {selection}
      FROM {from}
    |]

countT :: H.Query a b -> H.Query a Int64
countT (H.Query sql enc _ prep) =
  H.Query sql' enc (HD.singleRow (HD.value HD.int8)) prep
 where
  sql' = [qc|
      SELECT pg_catalog.count(1)
      FROM ({sql}) AS countme
    |]

orderByT :: [Escaped] ->
  H.Query a b -> H.Query a b
orderByT [] q = q
orderByT cols (H.Query sql enc dec prep) =
  H.Query sql' enc dec prep
 where
  sql'  = [qc| {sql} ORDER BY {order} |]
  order = BS.intercalate "," cols

whereT :: [Escaped] ->
  H.Query a b -> H.Query a b
whereT [] q = q
whereT conditions (H.Query sql enc dec prep) =
  H.Query sql' enc dec prep
 where
  sql'   = [qc| {sql} WHERE {clause} |]
  clause = BS.intercalate " AND " conditions

leftJoinT :: [Escaped] ->
  H.Query a b -> H.Query a b
leftJoinT [] q = q
leftJoinT conditions (H.Query sql enc dec prep) =
  H.Query sql' enc dec prep
 where
  sql'   = [qc| LEFT OUTER JOIN {sql} ON {clause} |]
  clause = BS.intercalate " AND " conditions

jsonArrayT :: H.Query a b -> H.Query a HD.Value
jsonArrayT (H.Query sql enc _ prep) =
  H.Query sql' enc (HD.singleRow (HD.value HD.json)) prep
 where
   sql' = [qc| COALESCE (
                 ( SELECT array_to_json(array_agg(row_to_json(jsonifyMe)))
                   FROM ({sql}) jsonifyMe
                 ), []
               ) |]

withT :: H.Query () () -> Escaped -> H.Query a b -> H.Query a b
withT (H.Query withSql _ _ withPrep) alias (H.Query bodySql enc dec bodyPrep) =
  H.Query sql' enc dec (withPrep && bodyPrep)
 where
  sql' = [qc| WITH ({withSql}) AS {alias} {bodySql} |]

limitT :: NonnegRange -> H.Query a b -> H.Query a b
limitT r (H.Query sql enc dec prep) =
  H.Query sql' enc dec prep
 where
  sql' = [qc| {sql} LIMIT {lim} OFFSET {off} |]
  lim  = maybe "ALL" (cs . show) $ rangeLimit r
  off  = cs . show $ rangeOffset r

csvT :: H.Query a b -> H.Query a ()
csvT (H.Query sql enc _ prep) =
  H.query sql' enc (HD.void) prep
 where
  sql' = [qc| WITH payload AS ({sql})
              (SELECT string_agg(a.k, ',')
                FROM (
                  SELECT json_object_keys(r)::TEXT as k
                  FROM (
                    SELECT row_to_json(hh) as r from payload as hh limit 1
                  ) s
                ) a
              ) || '\n' ||
              coalesce(string_agg(substring(t::text, 2, length(t::text) - 2), '\n'), '')
          |]

requestToCountQuery :: Schema -> DbRequest -> H.Query () Int64
requestToCountQuery _ (DbMutate _) = undefined
requestToCountQuery schema (DbRead (Node (Select _ _ conditions _, (mainTbl, _)) _)) =
  countT . whereT localConditions $ select ["1"] [qi]
 where
  isText  (Filter{value=VText _}) = True
  isText  (Filter{value=VForeignKey _ _}) = False
  localConditions = map (pgFmtCondition qi) $ filter isText conditions
  qi = QualifiedIdentifier schema mainTbl

escapeOrderTerm :: OrderTerm -> Escaped
escapeOrderTerm ot =
  cs $ (pgFmtColumn qi $ otTerm t) <> " "
    <> show (otDirection t) <> " "
    <> fromMaybe "" (show <$> otNullOrder t)

requestToQuery :: Schema -> DbRequest -> SqlQuery
requestToQuery _ (DbMutate (Insert _ (PayloadParseError _))) = undefined
requestToQuery _ (DbMutate (Update _ (PayloadParseError _) _)) = undefined
requestToQuery schema (DbRead (Node (Select colSelects tbls conditions ord, (nodeName, maybeRelation)) forest)) =
  orderByT (map escapeOrderTerm ord) . whereT whereConds $ select cols tables
 where
  qi = QualifiedIdentifier (tblSchema mainTbl) mainTbl
  (joins, selects) = foldr getQueryParts ([],[]) forest
  cols = map (pgFmtSelectItem qi) colSelects ++ selects
  tables = map (fromQi . toQi) tbls
  toQi t = QualifiedIdentifier (tblSchema t) t

  parentTables = map snd joins
  parentConditions = join $ map (( `filter` conditions ) . filterParentConditions) parentTables
  localConditions = conditions \\ parentConditions
  whereConds = map (pgFmtCondition qi) localConditions

    -- TODO! the folloing helper functions are just to remove the "schema" part when the table is "source" which is the name
    -- of our WITH query part
    joinStr :: (SqlFragment, TableName) -> SqlFragment
    joinStr (sql, t) = "LEFT OUTER JOIN " <> sql <> " ON " <>
      BS.intercalate " AND " ( map (pgFmtCondition qi ) joinConditions )
      where
        joinConditions = filter (filterParentConditions t) conditions

    filterParentConditions parentTable (Filter _ _ (VForeignKey (QualifiedIdentifier "" t) _)) = parentTable == t
    filterParentConditions _ _ = False

    getQueryParts :: Tree ReadNode -> ([(SqlFragment, TableName)], [SqlFragment]) -> ([(SqlFragment,TableName)], [SqlFragment])


    -- getQueryParts (Node n@(_, (name, Just (Relation {relType=Child, relTable=Table{tableName=table}}))) forst) (j,s) = (j,    sel:s)
    -- getQueryParts (Node n@(_, (name, Just (Relation {relType=Parent,relTable=Table{tableName=table}}))) forst) (j,s) = (joi:j,sel:s)
    -- getQueryParts (Node n@(_, (name, Just (Relation {relType=Many,  relTable=Table{tableName=table}}))) forst) (j,s) = (j,    sel:s)
    -- getQueryParts (Node (_,(_,Nothing)) _) _ = undefined


    getQueryParts (Node n@(_, (name, Just (Relation {relType=Child,relTable=Table{tableName=table}}))) forst) (j,s) = (j,sel:s)
      where
        sel = "COALESCE(("
           <> "SELECT array_to_json(array_agg(row_to_json("<>pgFmtIdent table<>"))) "
           <> "FROM (" <> subquery <> ") " <> pgFmtIdent table
           <> "), '[]') AS " <> pgFmtIdent name
           where subquery = requestToQuery schema (DbRead (Node n forst))
    getQueryParts (Node n@(_, (name, Just (Relation {relType=Parent,relTable=Table{tableName=table}}))) forst) (j,s) = (joi:j,sel:s)
      where
        sel = "row_to_json(" <> pgFmtIdent table <> ".*) AS "<>pgFmtIdent name --TODO must be singular
        joi = ("( " <> subquery <> " ) AS " <> pgFmtIdent table, table)
          where subquery = requestToQuery schema (DbRead (Node n forst))
    getQueryParts (Node n@(_, (name, Just (Relation {relType=Many,relTable=Table{tableName=table}}))) forst) (j,s) = (j,sel:s)
      where
        sel = "COALESCE (("
           <> "SELECT array_to_json(array_agg(row_to_json("<>pgFmtIdent table<>"))) "
           <> "FROM (" <> subquery <> ") " <> pgFmtIdent table
           <> "), '[]') AS " <> pgFmtIdent name
           where subquery = requestToQuery schema (DbRead (Node n forst))
    --the following is just to remove the warning
    --getQueryParts is not total but requestToQuery is called only after addJoinConditions which ensures the only
    --posible relations are Child Parent Many
    getQueryParts (Node (_,(_,Nothing)) _) _ = undefined
requestToQuery schema (DbMutate (Insert mainTbl (PayloadJSON (UniformObjects rows)))) =
  let qi = QualifiedIdentifier schema mainTbl
      cols = map pgFmtIdent $ fromMaybe [] (HM.keys <$> (rows V.!? 0))
      colsString = BS.intercalate ", " cols in
  unwords [
    "INSERT INTO ", fromQi qi,
    " (" <> colsString <> ")" <>
    " SELECT " <> colsString <>
    " FROM json_populate_recordset(null::" , fromQi qi, ", ?)"
    ]
requestToQuery schema (DbMutate (Update mainTbl (PayloadJSON (UniformObjects rows)) conditions)) =
  case rows V.!? 0 of
    Just obj ->
      let assignments = map
            (\(k,v) -> pgFmtIdent k <> "=" <> insertableValue v) $ HM.toList obj in
      unwords [
        "UPDATE ", fromQi qi,
        " SET " <> BS.intercalate "," assignments <> " ",
        ("WHERE " <> BS.intercalate " AND " ( map (pgFmtCondition qi ) conditions )) `emptyOnNull` conditions
        ]
    Nothing -> undefined
  where
    qi = QualifiedIdentifier schema mainTbl

requestToQuery schema (DbMutate (Delete mainTbl conditions)) =
  query
  where
    qi = QualifiedIdentifier schema mainTbl
    query = unwords [
      "DELETE FROM ", fromQi qi,
      ("WHERE " <> BS.intercalate " AND " ( map (pgFmtCondition qi ) conditions )) `emptyOnNull` conditions
      ]

sourceCTEName = "pg_source"

unquoted :: JSON.Value -> Text
unquoted (JSON.String t) = t
unquoted (JSON.Number n) =
  cs $ formatScientific Fixed (if isInteger n then Just 0 else Nothing) n
unquoted (JSON.Bool b) = cs . show $ b
unquoted v = cs $ JSON.encode v

-- private functions
asCsvF :: SqlFragment
asCsvF = asCsvHeaderF <> " || '\n' || " <> asCsvBodyF
  where
    asCsvHeaderF =
      "(SELECT string_agg(a.k, ',')" <>
      "  FROM (" <>
      "    SELECT json_object_keys(r)::TEXT as k" <>
      "    FROM ( " <>
      "      SELECT row_to_json(hh) as r from " <> sourceCTEName <> " as hh limit 1" <>
      "    ) s" <>
      "  ) a" <>
      ")"
    asCsvBodyF = "coalesce(string_agg(substring(t::text, 2, length(t::text) - 2), '\n'), '')"

asJsonF :: SqlFragment
asJsonF = "array_to_json(array_agg(row_to_json(t)))::character varying"

asJsonSingleF :: SqlFragment --TODO! unsafe when the query actually returns multiple rows, used only on inserting and returning single element
asJsonSingleF = "string_agg(row_to_json(t)::text, ',')::character varying "

locationF :: [Text] -> SqlFragment
locationF pKeys =
    "(" <>
    " WITH s AS (SELECT row_to_json(ss) as r from " <> sourceCTEName <> " as ss  limit 1)" <>
    " SELECT string_agg(json_data.key || '=' || coalesce( 'eq.' || json_data.value, 'is.null'), '&')" <>
    " FROM s, json_each_text(s.r) AS json_data" <>
    (
      if null pKeys
      then ""
      else " WHERE json_data.key IN ('" <> BS.intercalate "','" pKeys <> "')"
    ) <>
    ")"

limitF :: NonnegRange -> SqlFragment
limitF r  = "LIMIT " <> limit <> " OFFSET " <> offset
  where
    limit  = maybe "ALL" (cs . show) $ rangeLimit r
    offset = cs . show $ rangeOffset r

fromQi :: QualifiedIdentifier -> SqlFragment
fromQi t = (if s == "" then "" else pgFmtIdent s <> ".") <> pgFmtIdent n
  where
    n = qiName t
    s = qiSchema t

getJoinConditions :: Relation -> [Filter]
getJoinConditions (Relation t cols ft fcs typ lt lc1 lc2) =
  case typ of
    Child  -> zipWith (toFilter tN ftN) cols fcs
    Parent -> zipWith (toFilter tN ftN) cols fcs
    Many   -> zipWith (toFilter tN ltN) cols (fromMaybe [] lc1) ++ zipWith (toFilter ftN ltN) fcs (fromMaybe [] lc2)
  where
    s = if typ == Parent then "" else tableSchema t
    tN = tableName t
    ftN = tableName ft
    ltN = fromMaybe "" (tableName <$> lt)
    toFilter :: Text -> Text -> Column -> Column -> Filter
    toFilter tb ftb c fc = Filter (colName c, Nothing) "=" (VForeignKey (QualifiedIdentifier s tb) (ForeignKey fc{colTable=(colTable fc){tableName=ftb}}))

emptyOnNull :: Text -> [a] -> Text
emptyOnNull val x = if null x then "" else val

insertableValue :: JSON.Value -> SqlFragment
insertableValue JSON.Null = "null"
insertableValue v = (<> "::unknown") . pgFmtLit $ unquoted v

whiteList :: Text -> SqlFragment
whiteList val = fromMaybe
  (cs (pgFmtLit val) <> "::unknown ")
  (find ((==) . toLower $ val) ["null","true","false"])

pgFmtColumn :: QualifiedIdentifier -> Text -> SqlFragment
pgFmtColumn table "*" = fromQi table <> ".*"
pgFmtColumn table c = fromQi table <> "." <> pgFmtIdent c

pgFmtField :: QualifiedIdentifier -> Field -> SqlFragment
pgFmtField table (c, jp) = pgFmtColumn table c <> pgFmtJsonPath jp

pgFmtSelectItem :: QualifiedIdentifier -> SelectItem -> SqlFragment
pgFmtSelectItem table (f@(_, jp), Nothing) = pgFmtField table f <> pgFmtAsJsonPath jp
pgFmtSelectItem table (f@(_, jp), Just cast ) = "CAST (" <> pgFmtField table f <> " AS " <> cast <> " )" <> pgFmtAsJsonPath jp

pgFmtCondition :: QualifiedIdentifier -> Filter -> Escaped
pgFmtCondition table (Filter (col,jp) ops val) =
  notOp <> " " <> sqlCol  <> " " <> pgFmtOperator opCode <> " " <>
    if opCode `elem` ["is","isnot"] then whiteList (getInner val) else sqlValue
  where
    headPredicate:rest = split (=='.') ops
    hasNot caseTrue caseFalse = if headPredicate == "not" then caseTrue else caseFalse
    opCode      = hasNot (head rest) headPredicate
    notOp       = hasNot headPredicate ""
    sqlCol = case val of
      VText _ -> pgFmtColumn table col <> pgFmtJsonPath jp
      VForeignKey qi _ -> pgFmtColumn qi col
    sqlValue = valToStr val
    getInner v = case v of
      VText s -> s
      _      -> ""
    valToStr v = case v of
      VText s -> pgFmtValue opCode s
      VForeignKey (QualifiedIdentifier s _) (ForeignKey Column{colTable=Table{tableName=ft}, colName=fc}) -> pgFmtColumn qi fc
        where qi = QualifiedIdentifier (if ft == sourceCTEName then "" else s) ft
      _ -> ""

pgFmtValue :: Text -> Text -> SqlFragment
pgFmtValue opCode val =
 case opCode of
   "like" -> unknownLiteral $ T.map star val
   "ilike" -> unknownLiteral $ T.map star val
   "in" -> "(" <> BS.intercalate ", " (map unknownLiteral $ split (==',') val) <> ") "
   "notin" -> "(" <> BS.intercalate ", " (map unknownLiteral $ split (==',') val) <> ") "
   "@@" -> "to_tsquery(" <> unknownLiteral val <> ") "
   _    -> unknownLiteral val
 where
   star c = if c == '*' then '%' else c
   unknownLiteral = (<> "::unknown ") . pgFmtLit

pgFmtOperator :: Text -> SqlFragment
pgFmtOperator opCode = fromMaybe "=" $ M.lookup opCode operatorsMap
  where
    operatorsMap = M.fromList operators

pgFmtJsonPath :: Maybe JsonPath -> SqlFragment
pgFmtJsonPath (Just [x]) = "->>" <> pgFmtLit x
pgFmtJsonPath (Just (x:xs)) = "->" <> pgFmtLit x <> pgFmtJsonPath ( Just xs )
pgFmtJsonPath _ = ""

pgFmtAsJsonPath :: Maybe JsonPath -> SqlFragment
pgFmtAsJsonPath Nothing = ""
pgFmtAsJsonPath (Just xx) = " AS " <> last xx

trimNullChars :: Text -> Text
trimNullChars = T.takeWhile (/= '\x0')
