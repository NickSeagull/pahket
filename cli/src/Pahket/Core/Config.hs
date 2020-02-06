{-# LANGUAGE DuplicateRecordFields #-}

module Pahket.Core.Config
  ( Config (..),
    Package (..),
    Dependency (..),
    configCodec,
  )
where

import Toml

data Config
  = Config
      { package :: Package,
        dependencies :: [Dependency]
      }
  deriving (Generic, Show)

configCodec :: TomlCodec Config
configCodec = genericCodec

data Package
  = Package
      { name :: Text,
        version :: Text,
        authors :: [Text]
      }
  deriving (Generic, Show)

instance HasCodec Package where
  hasCodec = Toml.table genericCodec

data Dependency
  = Dependency
      { name :: Text,
        git :: Text
      }
  deriving (Generic, Show)

instance HasItemCodec Dependency where
  hasItemCodec = Right genericCodec
