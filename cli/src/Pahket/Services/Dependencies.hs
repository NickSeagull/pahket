module Pahket.Services.Dependencies
  ( parse,
    download,
    ExternalInclude (..),
  )
where

import qualified Pahket.Services.FileSystem as FileSystem
import qualified Pahket.Services.Git as Git
import qualified RIO.FilePath as FilePath
import qualified RIO.Text as Text

newtype ExternalInclude = ExternalInclude {unExternalInclude :: Text}

parse :: FileSystem.Access env => RIO env [ExternalInclude]
parse = do
  FileSystem.Service {listAllFiles, readFile} <- view FileSystem.access
  allFiles <- listAllFiles "."
  let ahkFiles = filter (\file -> FilePath.takeExtension file == ".ahk") allFiles
  contents <- traverse readFile ahkFiles
  pure (concatMap getIncludes contents)

download :: FileSystem.Access env => ExternalInclude -> RIO env ()
download (ExternalInclude include) = do
  let (user : repo : _) =
        Text.dropWhile (== '@') include
          & Text.split (== '/')
  Git.clone user repo "lib"

getIncludes :: Text -> [ExternalInclude]
getIncludes fileContents =
  Text.lines fileContents
    & filter (\line -> "#include" `Text.isPrefixOf` Text.toLower line)
    & map (Text.dropWhile (/= ' '))
    & map Text.strip
    & filter ("@" `Text.isPrefixOf`)
    & nubOrd
    & map ExternalInclude
