module Pahket.App (Services) where

import qualified Pahket.Services.FileSystem as FileSystem

newtype Services env
  = Services
      { fileSystemService :: FileSystem.Service
      }

instance FileSystem.Access (Services env) where
  access = lens fileSystemService (\services fs -> services {fileSystemService = fs})
