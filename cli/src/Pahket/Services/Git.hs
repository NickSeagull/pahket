{-# LANGUAGE QuasiQuotes #-}

module Pahket.Services.Git
  ( clone,
  )
where

import qualified Pahket.Services.FileSystem as FileSystem
import qualified RIO.Text as Text
import qualified System.Process.Typed as Process

clone :: FileSystem.Access env => Text -> Text -> FilePath -> RIO env ()
clone user repo destination = do
  FileSystem.Service {doesDirExist} <- view FileSystem.access
  let url = [i|https://github.com/#{user}/#{repo}.git|]
  let destinationFolder = destination </> Text.unpack repo
  alreadyInstalled <- doesDirExist destinationFolder
  unless alreadyInstalled $
    Process.runProcess_ (Process.proc "git" ["clone", url, destinationFolder])
