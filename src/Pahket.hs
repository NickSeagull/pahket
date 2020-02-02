module Pahket
  ( run,
  )
where

-- import Pahket.Core

import Data.Aeson (FromJSON (..))
import Network.HTTP.Types.Status
import Network.Wai.Handler.Warp (defaultSettings, setPort)
import Web.Scotty as HTTP

run :: IO ()
run = scottyOpts (def {verbose = 0, settings = setPort 3000 defaultSettings})
  $ HTTP.post "/log"
  $ do
    logMessage <- jsonData
    putTextLn logMessage
    status status200
    text ""
