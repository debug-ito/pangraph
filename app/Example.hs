{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import qualified Data.ByteString as B
import Pangraph (makePangraph, makeVertex, makeEdge)
import qualified Pangraph.GraphML.Writer as GraphML

main :: IO ()
main = B.putStrLn $ GraphML.write graph
  where
    (Just graph) = makePangraph vertices edges
    vertices = [ makeVertex "foo" [],
                 makeVertex "bar" [],
                 makeVertex "buzz" []
               ]
    edges = [ makeEdge ("foo", "bar") [],
              makeEdge ("bar", "buzz") [],
              makeEdge ("buzz", "foo") []
            ]
