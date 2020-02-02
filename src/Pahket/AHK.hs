{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Pahket.AHK
  ( run,
    exampleProgram,
  )
where

import qualified System.IO as IO
import qualified System.IO.Temp as Temp

run ::
  WithLog env Message m =>
  MonadMask m =>
  MonadIO m =>
  Text ->
  m ()
run contents = Temp.withSystemTempFile "pahket-eval.ahk" $ \filepath hnd -> do
  liftIO $ IO.hPutStrLn hnd (toString $ preparePahket contents)
  liftIO $ IO.hFlush hnd
  let ahk = "C:\\Program Files\\AutoHotkey\\AutoHotkey.exe"
  let args = ["/ErrorStdOut", filepath, "2>&1", "|more"]
  (_, _, err) <- readProcess $ proc ahk args
  putLBSLn err

preparePahket :: Text -> Text
preparePahket script =
  [i|
  #{includeJxon}
  #{includeUtil}
  try {
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
