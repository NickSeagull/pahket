module Pahket.AHKSpec (spec) where

import Test.Hspec

spec :: Spec
spec = pure ()
-- See https://github.com/NickSeagull/pahket/issues/8
--
-- import qualified Pahket
-- import qualified Pahket.AHK as AHK
-- import Pahket.Core
-- import qualified System.IO.Silently as Silently
-- import qualified System.IO.Temp as Temp

-- spec :: Spec
-- spec = describe "the AHK runner"
--   $ it "is capable of printing to the STDOUT"
--   $ withEnv
--   $ \env -> do
--     ahkOutput <- Silently.capture_ (Pahket.runWithEnv env)
--     ahkOutput `shouldBe` "Hello world!"

-- withEnv ::
--   (Env App -> IO a) ->
--   IO a
-- withEnv action = do
--   filepath <- Temp.writeSystemTempFile "pahket-test.ahk" "print(\"Hello world!\")"
--   logSemaphore <- liftIO $ newQSem 1
--   serverSemaphore <- liftIO $ newQSem 0
--   action
--     Env
--       { envServerPort = 3000,
--         envInputFile = filepath,
--         envLogSemaphore = logSemaphore,
--         envServerSemaphore = serverSemaphore,
--         envLogAction = noLogAction
--       }
