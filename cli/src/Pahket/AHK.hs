module Pahket.AHK
  ( run,
  )
where

run :: IO ()
run = undefined
-- import qualified Control.Concurrent.QSem as QSem
-- import Pahket.Core
-- import qualified Pahket.Core.Config as Config
-- import qualified System.Directory as Directory
-- import qualified System.IO as IO
-- import qualified System.IO.Temp as Temp
-- import qualified System.Process.Typed as Process

-- run ::
--   MonadReader (Env m) m =>
--   WithLog env Message m =>
--   MonadMask m =>
--   MonadIO m =>
--   m ()
-- run = Temp.withTempFile "." "pahket" $ \filepath hnd -> do
--   cwd <- liftIO Directory.getCurrentDirectory
--   logDebug "Cloning dependencies"
--   maybeConfig <- asks envProjectConfig
--   let config = maybeConfig ?: error "No project config found, have you created a 'pahket.toml' file?"
--   forM_ (Config.dependencies config) $ \(Config.Dependency name git) -> do
--     downloadedAlready <- liftIO $ Directory.doesPathExist ("lib\\" <> toString name)
--     unless downloadedAlready
--       $ Process.runProcess_
--       $ Process.proc "git" ["clone", toString git, "lib\\" <> toString name]
--   logDebug "Getting input file name from env"
--   inputFilePath <- asks envInputFile
--   port <- asks envServerPort
--   logDebug "Preparing and saving to temporary file"
--   liftIO $ IO.hPutStrLn hnd (toString $ preparePahket port cwd inputFilePath)
--   logDebug "Flushing file"
--   liftIO $ IO.hFlush hnd
--   let ahk = "C:\\Program Files\\AutoHotkey\\AutoHotkey.exe"
--   let args = ["/ErrorStdOut", filepath, "2>&1", "|more"]
--   logDebug ("Spawning AutoHotkey with path " <> show ahk <> " and args " <> show args)
--   (_, _, err) <- Process.readProcess $ Process.proc ahk args
--   when (err /= "") $ do
--     logDebug "Printing STDERR"
--     putLBSLn err
--     serverSemaphore <- asks envServerSemaphore
--     liftIO $ QSem.signalQSem serverSemaphore

-- preparePahket :: Int -> FilePath -> FilePath -> Text
-- preparePahket port cwd inputFilePath =
--   [i|
--   OnExit, __pahket__autoremove__
--   SetWorkingDir, #{cwd}
--   #NoTrayIcon
--   global __PahketBaseURL__ := "http://localhost:" . "#{show port :: Text}"
--   try {
--   #Include <AutoHotkey-JSON\\Jxon>
--   #Include <PahketStdLib\\stdlib\\Interop>
--   #Include <PahketStdLib\\stdlib\\StdLib>
--   #Include #{inputFilePath}
--   } catch e {
--     print(e)
--   }
--   __Pahket__.exitServer()

--   __pahket__autoremove__:
--     filedelete, %A_ScriptFullPath%
--     exitapp
--   |]
