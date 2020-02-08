module Main (main) where

import qualified Pahket
import qualified System.Environment as Environment

main :: IO ()
main = do
  args <- Environment.getArgs
  Pahket.run args
