{-# LANGUAGE QuasiQuotes #-}

module Pahket.Commands.Help
  ( run,
  )
where

import qualified Data.Text as Text
import Pahket.Commands.Core (availableCommands)

run :: IO ()
run =
  putTextLn
    [i|
Usage: pahket <command>

where <command> is one of:
\t#{Text.intercalate ", " availableCommands }

A command might have more sub-commands, for more info, run:

pahket <command> help
|]
