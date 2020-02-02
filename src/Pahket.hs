module Pahket
  ( run,
  )
where

import Control.Concurrent (forkIO, killThread)
import Network.HTTP.Types.Status
import Network.Wai.Handler.Warp (defaultSettings, setPort)
import qualified Pahket.AHK as AHK
import Pahket.Core
import System.Environment (getArgs)
import Web.Scotty as HTTP

run :: IO ()
run = do
  (filename : _) <- getArgs
  contents <- readFileText filename
  finishIt <- newEmptyMVar
  t <- forkIO $ scottyOpts (def {verbose = 0, settings = setPort 3000 defaultSettings}) $ do
    HTTP.post "/log" $ do
      logMessage <- jsonData
      putTextLn logMessage
      status status200
      text ""
    HTTP.get "/end" $ do
      status status200
      putMVar finishIt ()
      text ""
  _ <- forkIO $ forever $ do
    _ <- readMVar finishIt
    killThread t
    exitSuccess
  runApp simpleEnv $ AHK.run contents
