{-# LANGUAGE TemplateHaskell #-}

module Pahket.Core.Version
  ( version,
  )
where

import qualified Data.Text as T
import qualified Relude.Unsafe as Unsafe

version :: Text
version =
  T.strip
    $ Unsafe.head
    $ Unsafe.tail
    $ T.split (== ':')
    $ Unsafe.head
    $ filter (T.isPrefixOf "version:")
    $ lines cabalContents
  where
    cabalContents :: Text
    cabalContents = $(embedStringFile "pahket.cabal")
