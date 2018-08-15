module Pangraph.GraphML.Parser (
parse,
unsafeParse
) where

import Data.Either
import Data.ByteString(ByteString)
import Pangraph
import qualified Pangraph.Internal.HexmlExtra       as H
import qualified Pangraph.Internal.XMLTemplate      as PT

-- * Parsing

-- | Throws on on failed XML parsing.
-- | Otherwise returns 'Right Pangraph' if the graph is well formed, listing 'Left [MalformedEdge]' otherwise.
parse :: ByteString -> Either [MalformedEdge] Pangraph
parse = PT.hexmlToPangraph PT.graphMLTemplate . H.hexmlParse

-- | Like 'parse' except it throws an error on Nothing, which is when parsing fails OR the graph is malformed.
unsafeParse :: ByteString -> Pangraph
unsafeParse file = fromRight (error "Parse failed") (parse file)
