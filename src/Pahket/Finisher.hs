module Pahket.Finisher (run) where

import Control.Concurrent (ThreadId, killThread)
import Pahket.Core
import qualified System.Exit as Exit

run :: Env App -> ThreadId -> IO ()
run Env {envServerSemaphore} serverThreadId = do
  waitQSem envServerSemaphore
  killThread serverThreadId
  Exit.exitSuccess
