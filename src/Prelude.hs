{-# LANGUAGE PatternSynonyms #-}

-- needed for ormolu

module Prelude
  ( module Relude,
    module Colog,
    module System.Process.Typed,
    module Data.FileEmbed,
    i,
    MonadMask (..),
    Default (..),
  )
where

import Colog
  ( HasLog (..),
    LogAction,
    Message,
    WithLog,
    log,
    richMessageAction,
    pattern D,
    pattern I,
  )
import Control.Monad.Catch
import Data.Default.Class
import Data.FileEmbed
import Data.String.Interpolate (i)
import Relude
import System.Process.Typed
