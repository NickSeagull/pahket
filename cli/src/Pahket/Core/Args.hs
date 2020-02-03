{-# LANGUAGE TypeOperators #-}

module Pahket.Core.Args
  ( get,
    Value (..),
  )
where

import qualified Data.Text as T
import Options.Generic
import qualified System.Environment as Env

data Value w
  = Value
      { verbose :: w ::: Bool <?> "Output Pahket debug messages",
        port :: w ::: Maybe Int <?> "Port that Pahket will use for IPC",
        version :: w ::: Bool <?> "Show Pahket version",
        inputFile :: w ::: String <?> "File to run"
      }
  deriving (Generic)

instance ParseRecord (Value Wrapped) where
  parseRecord = parseRecordWithModifiers lispCaseModifiers

deriving instance Show (Value Unwrapped)

get :: MonadIO m => m (Value Unwrapped)
get = do
  args <- liftIO Env.getArgs
  foo (map toText args)

foo :: MonadIO m => [Text] -> m (Value Unwrapped)
foo [x]
  | not ("--" `T.isInfixOf` x) =
    pure
      Value
        { verbose = False,
          port = Nothing,
          version = False,
          inputFile = toString x
        }
  | otherwise = unwrapRecord "pahket"
foo _ = unwrapRecord "pahket"
