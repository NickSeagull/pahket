{-# LANGUAGE PatternSynonyms #-}

-- needed for ormolu

module Prelude
  ( module Relude,
    module Colog,
    module System.Process.Typed,
    module Data.FileEmbed,
    i,
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
import Data.FileEmbed
import Data.String.Interpolate (i)
import Relude
import System.Process.Typed
