module Pahket.Core.Init
  ( env,
  )
where

import Control.Exception (IOException)
import qualified Pahket.Core.Args as Args
import Pahket.Core.Common
import qualified Pahket.Core.Config as Config
import Pahket.Core.Logging (noLogAction)
import qualified Pahket.Core.Version as V
import Toml hiding (Env)

env :: IO (Env App)
env = do
  config <- loadConfig
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
            envLogAction = if verbose then richMessageAction else noLogAction,
            envProjectConfig = config
          }

loadConfig :: IO (Maybe Config.Config)
loadConfig = do
  configContents <- readFileMaybe "pahket.toml"
  case configContents of
    Nothing ->
      pure Nothing
    Just txt ->
      pure (either (const Nothing) Just $ decodeConfig txt)
  where
    readFileMaybe :: FilePath -> IO (Maybe Text)
    readFileMaybe fp =
      catch (Just <$> readFileText fp) (\(_ :: IOException) -> pure Nothing)
    decodeConfig = Toml.decode Config.configCodec
