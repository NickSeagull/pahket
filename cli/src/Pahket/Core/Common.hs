module Pahket.Core.Common
  ( Env (..),
    App (..),
    runApp,
  )
where

-- | Environment that is shared throughout the application
data Env m
  = Env
      { envServerPort :: !Int,
        envInputFile :: !FilePath,
        envLogSemaphore :: !QSem,
        envLogAction :: !(LogAction m Message),
        envServerSemaphore :: !QSem
      }

-- | The env has logging
instance HasLog (Env m) Message m where
  getLogAction :: Env m -> LogAction m Message
  getLogAction = envLogAction
  {-# INLINE getLogAction #-}

  setLogAction :: LogAction m Message -> Env m -> Env m
  setLogAction newLogAction env = env {envLogAction = newLogAction}
  {-# INLINE setLogAction #-}

-- | App type that is shared
newtype App a
  = App
      { unApp :: ReaderT (Env App) IO a
      }
  deriving newtype (Functor, Applicative, Monad, MonadIO, MonadReader (Env App), MonadThrow, MonadCatch, MonadMask)

runApp :: Env App -> App a -> IO a
runApp env app = runReaderT (unApp app) env
