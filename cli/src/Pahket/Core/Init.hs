module Pahket.Core.Init
  ( env,
  )
where

import qualified Pahket.Core.Args as Args
import Pahket.Core.Common
import Pahket.Core.Logging (noLogAction)
import qualified Pahket.Core.Version as V

env :: IO (Env App)
env = do
  Args.Value {verbose, port, version, inputFile} <- Args.get
  if version
    then do
      putTextLn V.version
      exitSuccess
    else do
      logSemaphore <- newQSem 1
      serverSemaphore <- newQSem 0
      pure $
        Env
          { envServerPort = port ?: 3000,
            envInputFile = inputFile,
            envLogSemaphore = logSemaphore,
            envServerSemaphore = serverSemaphore,
            envLogAction = if verbose then richMessageAction else noLogAction
          }
