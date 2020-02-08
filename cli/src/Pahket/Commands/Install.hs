module Pahket.Commands.Install
  ( run,
  )
where

import qualified Pahket.Services.Dependencies as Dependencies
import qualified Pahket.Services.FileSystem as FileSystem

run :: IO ()
run = do
  fs <- FileSystem.new
  runRIO fs runCommand

runCommand :: FileSystem.Access env => RIO env ()
runCommand = do
  gitIncludes <- Dependencies.parse
  traverse_ Dependencies.download gitIncludes
