-- code below is modification of https://hackage.haskell.org/package/wai-app-static-3.1.6.1/docs/src/WaiAppStatic-Listing.html

{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}

import Control.Monad (filterM, liftM2)
import System.Directory ( doesFileExist, doesDirectoryExist
                        , getModificationTime, getFileSize
                        , listDirectory )
import Data.Char (toLower)
import Data.Time
import Data.Time.Clock.POSIX
import Data.List
import Lucid
import System.IO (stdout, hSetEncoding, utf8)
import System.Environment (getArgs)
import Data.Text.Lazy.IO as L
import qualified Data.Text as T


main :: IO ()
main = do
  args <- getArgs
  let dir =
        if null args
          then "."
          else head args
  fs1 <- listDirectory dir
  let fs2 = filter ((/= '.') . head) $ filter (not . null) fs1
  let fs3 = filter (not . isPrefixOf "index.htm" . map toLower) fs2
  fs <- filterM (\n -> liftM2 (||) (doesFileExist n) (doesDirectoryExist n)) fs3
  fps <- mapM fileHelper fs
  hSetEncoding stdout utf8
  L.hPutStr stdout $ renderText $ template1 dir fps
  -- mapM_ (putStrLn . (\n -> mkRow (n, True))) $ sortBy sortMD fsE 


type FolderName = String

data File = File
    { -- | Size of file in bytes
      fileGetSize :: Integer
      -- | Last component of the filename.
    , fileName :: String
      -- | Last modified time, used for both display in listings and if-modified-since.
    , fileGetModified :: UTCTime
    }

fileHelper :: FilePath -> IO (Either FolderName File)
fileHelper fname = do
  de <- doesDirectoryExist fname
  if de
    then return $ Left fname
    else do
      fe <- doesFileExist fname
      if fe
        then do
          size <- getFileSize fname
          t <- getModificationTime fname
          return $ Right $ File size fname t
        else error $ fname ++ " isn't file or directory"

template1 :: FilePath -> [Either FolderName File] -> Html ()
template1 dir fps = do
  let dir' = toHtml dir
  html_ $ do
    head_ $ do
      title_ dir' 
      style_ $ do 
        T.unlines [ "table { margin: 0 auto; width: 760px; border-collapse: collapse; font-family: 'sans-serif'; }"
                  , "table, th, td { border: 1px solid #353948; }"
                  , "td.size { text-align: right; font-size: 0.7em; width: 50px }"
                  , "td.date { text-align: right; font-size: 0.7em; width: 130px }"
                  , "td { padding-right: 1em; padding-left: 1em; }"
                  , "th.first { background-color: white; width: 24px }"
                  , "td.first { padding-right: 0; padding-left: 0; text-align: center }"
                  , "tr { background-color: white; }"
                  , "tr.alt { background-color: #A3B5BA}"
                  , "th { background-color: #3C4569; color: white; font-size: 1.125em; }"
                  , "h1 { width: 760px; margin: 1em auto; font-size: 1em; font-family: sans-serif }"
                  , "img { width: 20px }"
                  , "a { text-decoration: none }"
                  ]
    body_ $ do
      h1_ dir'
      table_ $ do
        thead_ $ do
          th_ [ class_ "first" ] $ do
            img_ [ src_ haskellSrc ]
          th_ $ do
            "Name"
          th_ $ do
            "Modified"
          th_ $ do
            "Size"
        tbody_ $ mapM_ mkRow (zip (Left ".." : sortBy sortMD fps) $ cycle [False, True])
  where
    sortMD :: Either FolderName File -> Either FolderName File -> Ordering
    sortMD Left{} Right{} = LT
    sortMD Right{} Left{} = GT
    sortMD (Left a) (Left b) = compare a b
    sortMD (Right a) (Right b) = compare (fileName a) (fileName b)

    mkRow :: (Either FolderName File, Bool) -> Html () 
    mkRow (md, alt) =
      tr_ (if alt then [ class_ "alt" ] else []) $ do
        td_ [ class_ "first" ]
            $ case md of
                Left{} -> img_ [ src_ folderSrc, alt_ "Folder" ]
                Right{} -> return ()
        let name = T.pack $ either id fileName md
        td_ $ a_ [ href_ name ] $ toHtml name
        td_ [ class_ "date" ] $ toHtml $
            case md of
                Right File { fileGetModified = t } ->
                        formatTime defaultTimeLocale "%d-%b-%Y %X" t
                _ -> ""
        td_ [ class_ "size" ] $ toHtml $
            case md of
                Right File { fileGetSize = s } -> prettyShow s
                Left{} -> ""

    image x = T.pack $ concat ["/images/", x, ".png"]
    folderSrc = image "folder"
    haskellSrc = image "haskell"

    prettyShow x
      | x > 1024 = prettyShowK $ x `div` 1024
      | otherwise = addCommas "B" x
    prettyShowK x
      | x > 1024 = prettyShowM $ x `div` 1024
      | otherwise = addCommas "KB" x
    prettyShowM x
      | x > 1024 = prettyShowG $ x `div` 1024
      | otherwise = addCommas "MB" x
    prettyShowG x = addCommas "GB" x

    addCommas s = (++ (' ' : s)) . reverse . addCommas' . reverse . show
    addCommas' (a:b:c:d:e) = a : b : c : ',' : addCommas' (d : e)
    addCommas' x = x

