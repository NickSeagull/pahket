module Pahket.Core
  ( Env (..),
    HasLog (..),
    App (..),
    simpleEnv,
    runApp,
  )
where

import Control.Monad.Catch

data Env m
  = Env
      { envServerPort :: !Int,
        envLogAction :: !(LogAction m Message)
      }

instance HasLog (Env m) Message m where
  getLogAction :: Env m -> LogAction m Message
  getLogAction = envLogAction
  {-# INLINE getLogAction #-}

  setLogAction :: LogAction m Message -> Env m -> Env m
  setLogAction newLogAction env = env {envLogAction = newLogAction}
  {-# INLINE setLogAction #-}

newtype App a
  = App
      { unApp :: ReaderT (Env App) IO a
      }
  deriving newtype (Functor, Applicative, Monad, MonadIO, MonadReader (Env App), MonadThrow, MonadCatch, MonadMask)

simpleEnv :: Env App
simpleEnv =
  Env
    { envServerPort = 8081,
      envLogAction = richMessageAction
    }

runApp :: Env App -> App a -> IO a
runApp env app = runReaderT (unApp app) env
