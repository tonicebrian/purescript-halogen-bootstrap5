#!/usr/bin/env stack
-- stack --resolver lts-21.14 script --package casing

import Text.Casing

classToClassName :: String -> IO ()
classToClassName orig = do
  putStrLn $ camel orig <> " :: ClassName"
  putStrLn $ camel orig <> " = ClassName \"" <> orig <> "\""
  putStrLn ""

main :: IO ()
main = do
  content <- readFile "classes.txt"
  let classes = lines content
  putStrLn "module Halogen.Themes.Bootstrap5 where\n"
  putStrLn "import Halogen.HTML.Core (ClassName(..))\n"
  mapM_ classToClassName classes
