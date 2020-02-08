{-# LANGUAGE PatternSynonyms #-}

-- needed for ormolu

module Prelude
  ( module Relude,
    module Colog,
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
import Control.Monad.Catch
import Data.Default.Class
import Data.String.Interpolate (i)
import Relude hiding (get)
