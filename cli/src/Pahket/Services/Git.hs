{-# LANGUAGE QuasiQuotes #-}

module Pahket.Services.Git
  ( clone,
  )
where

import qualified Pahket.Services.FileSystem as FileSystem
import qualified RIO.FilePath as FilePath
import qualified RIO.Text as Text
import qualified System.Process.Typed as Process

clone :: FileSystem.Access env => Text -> Text -> FilePath -> RIO env ()
clone user repo destination = do
  FileSystem.Service {doesDirExist, listAllFiles, renameFile} <- view FileSystem.access
  let url = [i|https://github.com/#{user}/#{repo}.git|]
  let destinationFolder = destination </> Text.unpack repo
  alreadyInstalled <- doesDirExist destinationFolder
  unless alreadyInstalled $ do
    Process.runProcess_ (Process.proc "git" ["clone", url, destinationFolder])
    ahkFiles <- listAllFiles destinationFolder
    let isAhkFile f = (".git" `Text.isInfixOf` fromString f) || not (".ahk" `Text.isSuffixOf` fromString f)
    traverse_
      ( \file -> unless (isAhkFile file) $ do
          let destFile = destination </> FilePath.takeFileName file
          renameFile file destFile
      )
      ahkFiles
