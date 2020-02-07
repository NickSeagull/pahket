{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Pahket.AHK
  ( run,
  )
where

import Pahket.Core
import qualified Pahket.Core.Config as Config
import qualified System.IO as IO
import qualified System.IO.Temp as Temp

run ::
  MonadReader (Env m) m =>
  WithLog env Message m =>
  MonadMask m =>
  MonadIO m =>
  m ()
run = Temp.withTempFile "." "runner.ahk" $ \filepath hnd -> do
  logDebug "Cloning dependencies"
  maybeConfig <- asks envProjectConfig
  let config = maybeConfig ?: error "No project config found, have you created a 'pahket.toml' file?"
  forM_ (Config.dependencies config) $ \(Config.Dependency name git) ->
    runProcess_ $ proc "git" ["clone", toString git, "lib\\" <> toString name]
  logDebug "Getting input file name from env"
  inputFilePath <- asks envInputFile
  port <- asks envServerPort
  logDebug "Reading input file"
  contents <- readFileText inputFilePath
  logDebug "Preparing and saving to temporary file"
  liftIO $ IO.hPutStrLn hnd (toString $ preparePahket port inputFilePath)
  logDebug "Flushing file"
  liftIO $ IO.hFlush hnd
  let ahk = "C:\\Program Files\\AutoHotkey\\AutoHotkey.exe"
  let args = ["/ErrorStdOut", filepath, "2>&1", "|more"]
  logDebug ("Spawning AutoHotkey with path " <> show ahk <> " and args " <> show args)
  (_, _, err) <- readProcess $ proc ahk args
  when (err /= "") $ do
    logDebug "Printing STDERR"
    putLBSLn err
    serverSemaphore <- asks envServerSemaphore
    liftIO $ signalQSem serverSemaphore

preparePahket :: Int -> FilePath -> Text
preparePahket port inputFilePath =
  [i|
  MsgBox, #{takeDirectory inputFilePath}
  SetWorkingDir, #{takeDirectory inputFilePath}
  #NoTrayIcon
  global __PahketBaseURL__ := "http://localhost:" . "#{show port :: Text}"
  try {
  #Include <AutoHotkey-JSON\\Jxon>
  #Include <PahketStdLib\\stdlib\\StdLib>
  #Include #{inputFilePath}
  } catch e {
    print(e)
  }
  __Pahket__.exitServer()
  |]
