module Pahket.Commands.Version
  ( run,
  )
where

run :: IO ()
run = runSimpleApp $ logInfo "0.0.0"
