module Pahket
  ( run,
  )
where

import qualified Pahket.Commands.Help as Help
import qualified Pahket.Commands.Install as Install
import qualified Pahket.Commands.Run as Run
import qualified Pahket.Commands.Version as Version

run :: [String] -> IO ()
run ("version" : _) = Version.run
run ("install" : _) = Install.run
run ("run" : args) = Run.run args
run _ = Help.run
