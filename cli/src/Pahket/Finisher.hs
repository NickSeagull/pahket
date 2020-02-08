module Pahket.Finisher (run) where

import Control.Concurrent (ThreadId, killThread)
import qualified Control.Concurrent.QSem as QSem
import Pahket.Core
import qualified System.Exit as Exit

run :: Env App -> ThreadId -> IO ()
run Env {envServerSemaphore} serverThreadId = do
  QSem.waitQSem envServerSemaphore
  killThread serverThreadId
  Exit.exitSuccess
