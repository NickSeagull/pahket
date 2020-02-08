module Pahket.Core.Logging
  ( logInfo,
    logDebug,
    noLogAction,
  )
where

import qualified Colog
import qualified Control.Concurrent.QSem as QSem
import Pahket.Core.Common

-- | Log a text with debug severity
logDebug ::
  MonadReader (Env m) m =>
  WithLog env Message m =>
  MonadIO m =>
  Text ->
  m ()
logDebug = log D

-- | Log a text with info severity
logInfo ::
  MonadReader (Env m) m =>
  WithLog env Message m =>
  MonadIO m =>
  Text ->
  m ()
logInfo = log I

log ::
  MonadReader (Env m) m =>
  HasLog (Env m) (Colog.Msg sev) m =>
  WithLog env (Colog.Msg sev) m =>
  MonadIO m =>
  sev ->
  Text ->
  m ()
log pat msg = do
  sem <- asks envLogSemaphore
  liftIO $ QSem.waitQSem sem
  Colog.log pat msg
  liftIO $ QSem.signalQSem sem

noLogAction :: Applicative m => Colog.LogAction m a
noLogAction = Colog.LogAction (const $ pure ())
