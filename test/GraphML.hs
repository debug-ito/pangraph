{-# LANGUAGE OverloadedStrings #-}

module GraphML (
graphmlTests
) where

import Data.List (permutations)
import Test.HUnit

import Pangraph
import Pangraph.GraphML.Parser
import Pangraph.GraphML.Writer
import Pangraph.Examples.SampleGraph

graphmlTests :: [Test]
graphmlTests = [case1, case2, case3]

case1 :: Test
case1 =
  let
    file :: Maybe Pangraph
    file = parse "<?xml version=\"1.0\" encoding=\"UTF-8\"?> \
            \<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\"\
            \    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
            \    xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns\
            \     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">\
            \  <graph id=\"G\" edgedefault=\"undirected\">\
            \    <node id=\"n0\"/>\
            \    <node id=\"n1\"/>\
            \    <node id=\"n2\"/>\
            \    <edge id=\"e1\" source=\"n0\" target=\"n2\"/>\
            \    </graph>\
            \</graphml>"
  in TestCase $ assertEqual "GraphML Parse case 1" (Just smallGraph) file

case2 :: Test
case2 = TestCase $ assertEqual "GraphML Write case 1" (Just smallGraph) (parse . write $ smallGraph)

combinations :: [a] -> [b] -> [(a, b)]
combinations as bs = concat $ map (\a -> map (\b -> (a, b)) bs) as

case3 :: Test
case3 = TestCase $ assertBool "GraphML Write case: without explicit id attributes" is_ok
  where
    got = write input
    (Just input) = makePangraph vertices edges
    vertices = [ makeVertex "foo" [],
                 makeVertex "bar" [],
                 makeVertex "buzz" []
               ]
    edges = [ makeEdge ("foo", "bar") [],
              makeEdge ("bar", "buzz") [],
              makeEdge ("buzz", "foo") []
            ]
            
    -- Order of nodes and edges are undefined. So we generate all
    -- possible expectations.
    
    is_ok = any (== got) expectation_candidates
    all_exp_nodes = permutations
                    [ "    <node id=\"foo\"/>\n",
                      "    <node id=\"bar\"/>\n",
                      "    <node id=\"buzz\"/>\n"
                    ]
    all_exp_edges = permutations
                    [ "    <edge source=\"foo\" target=\"bar\"/>\n",
                      "    <edge source=\"bar\" target=\"buzz\"/>\n",
                      "    <edge source=\"buzz\" target=\"foo\"/>\n"
                    ]
    expectation_candidates = map (uncurry makeExpectation) $ combinations all_exp_nodes all_exp_edges
    makeExpectation exp_nodes exp_edges = 
      mconcat
      [ "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
        "<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n",
        "  <graph id=\"G\" edgedefault=\"undirected\">\n",
        mconcat exp_nodes,
        mconcat exp_edges,
        "  </graph>\n",
        "</graphml>"
      ]
