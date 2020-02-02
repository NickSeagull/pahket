{-# LANGUAGE PatternSynonyms #-}

-- needed for ormolu

module Prelude
  ( module Relude,
    module Colog,
    module System.Process.Typed,
    module Data.FileEmbed,
    module Control.Concurrent.QSem,
    i,
    MonadThrow (..),
    MonadCatch (..),
    MonadMask (..),
    Default (..),
  )
where

import Colog
  ( HasLog (..),
    LogAction,
    Message,
    WithLog,
    richMessageAction,
    pattern D,
    pattern I,
  )
import Control.Concurrent.QSem (QSem, newQSem, signalQSem, waitQSem)
import Control.Monad.Catch
import Data.Default.Class
import Data.FileEmbed
import Data.String.Interpolate (i)
import Relude hiding (get)
import System.Process.Typed
