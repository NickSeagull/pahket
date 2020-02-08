module Pahket.Server (run) where

import Control.Concurrent (ThreadId, forkIO)
import qualified Control.Concurrent.QSem as QSem
import Network.HTTP.Types.Status (status200)
import Network.Wai.Handler.Warp (defaultSettings, setPort)
import Pahket.Core
import Web.Scotty as HTTP

run :: Env App -> IO ThreadId
run env = forkIO
  $ scottyOpts (def {verbose = 0, settings = setPort 3000 defaultSettings})
  $ do
    HTTP.post "/stdout" $ do
      logMessage <- jsonData
      liftIO . runApp env $ do
        logDebug ("/stdout: Got message to print to STDOUT: " <> logMessage)
        putTextLn logMessage
        logDebug "/stdout: Message printed, returning status200"
      status status200
      text ""
    HTTP.get "/end" $ do
      status status200
      text ""
      liftIO $ QSem.signalQSem (envServerSemaphore env)
