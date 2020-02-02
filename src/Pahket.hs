module Pahket
  ( run,
  )
where

import Control.Concurrent (forkIO)
import qualified Pahket.AHK as AHK
import Pahket.Core
import qualified Pahket.Core.Init as Init
import qualified Pahket.Finisher as Finisher
import qualified Pahket.Server as Server

run :: IO ()
run = do
  env <- Init.env
  serverThreadId <- forkIO $ do
    _ <- Server.run env
    runApp env AHK.run
  Finisher.run env serverThreadId
