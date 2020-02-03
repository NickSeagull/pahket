{-# LANGUAGE DuplicateRecordFields #-}

module Pahket.Config where

import Toml

data Config
  = Config
      { package :: Package,
        dependencies :: [Dependency]
      }
  deriving (Generic)

configCodec :: TomlCodec Config
configCodec = genericCodec

data Package
  = Package
      { name :: Text,
        version :: Text,
        authors :: [Text]
      }
  deriving (Generic)

instance HasCodec Package where
  hasCodec = Toml.table genericCodec

data Dependency
  = Dependency
      { name :: Text,
        git :: Text
      }
  deriving (Generic)

instance HasItemCodec Dependency where
  hasItemCodec = Right genericCodec
