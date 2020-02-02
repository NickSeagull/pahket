{-# LANGUAGE TypeOperators #-}

module Pahket.Core.Args
  ( get,
    Value (..),
  )
where

import Options.Generic

data Value w
  = Value
      { verbose :: w ::: Bool <?> "Output Pahket debug messages",
        port :: w ::: Maybe Int <?> "Port that Pahket will use for IPC",
        version :: w ::: Bool <?> "Show Pahket version",
        inputFile :: w ::: String <?> "File to run"
      }
  deriving (Generic)

instance ParseRecord (Value Wrapped)

deriving instance Show (Value Unwrapped)

get :: MonadIO m => m (Value Unwrapped)
get =
  liftIO $ unwrapRecord "Pahket"
