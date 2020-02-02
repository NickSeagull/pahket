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
  log D (toText $ "Filepath: " <> filepath)
  (_, out, err) <- readProcess $ proc ahk args
  log I "StdOut (should be none):"
  log I (decodeUtf8 out)
  log I "StdErr"
  log I (decodeUtf8 err)

preparePahket :: Text -> Text
preparePahket script =
  [i|
  #{includeJxon}
  #{includeUtil}
  #{script}
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
