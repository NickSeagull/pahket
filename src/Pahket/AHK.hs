{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Pahket.AHK
  ( run,
    exampleProgram,
  )
where

import Pahket.Core
import qualified System.IO as IO
import qualified System.IO.Temp as Temp

run ::
  MonadReader (Env m) m =>
  WithLog env Message m =>
  MonadMask m =>
  MonadIO m =>
  m ()
run = Temp.withSystemTempFile "pahket.ahk" $ \filepath hnd -> do
  logDebug "Getting input file name from env"
  inputFile <- asks envInputFile
  logDebug "Reading input file"
  contents <- readFileText inputFile
  logDebug "Preparing and saving to temporary file"
  liftIO $ IO.hPutStrLn hnd (toString $ preparePahket contents)
  logDebug "Flushing file"
  liftIO $ IO.hFlush hnd
  let ahk = "C:\\Program Files\\AutoHotkey\\AutoHotkey.exe"
  let args = ["/ErrorStdOut", filepath, "2>&1", "|more"]
  logDebug ("Spawning AutoHotkey with path " <> show ahk <> " and args " <> show args)
  (_, _, err) <- readProcess $ proc ahk args
  logDebug "Printing STDERR"
  putLBSLn err

preparePahket :: Text -> Text
preparePahket script =
  [i|
  try {
  #{includeJxon}
  #{includeUtil}
  #{script}
  } catch e {
    print(e)
  }
  pahket_exit_server()
  |]
  where
    includeJxon = $(embedStringFile "ahk/Jxon.ahk") :: Text
    includeUtil = $(embedStringFile "ahk/Util.ahk") :: Text

exampleProgram :: Text
exampleProgram =
  [i|
print("hello")
print("hello1")
print("hello2")
print("hello3")
|]
