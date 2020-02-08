{-# LANGUAGE QuasiQuotes #-}

module Pahket.Commands.Help
  ( run,
  )
where

import Pahket.Commands.Core (availableCommands)
import qualified RIO.Text as Text

run :: IO ()
run =
  runSimpleApp $
    logInfo
      [i|
Usage: pahket <command>

where <command> is one of:
\t#{Text.intercalate ", " availableCommands }

A command might have more sub-commands, for more info, run:

pahket <command> help
|]
