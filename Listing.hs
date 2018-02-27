{-# LANGUAGE ViewPatterns #-}

import Control.Monad (filterM, liftM2)
import System.Directory ( doesFileExist, doesDirectoryExist
                        , getModificationTime, getFileSize
                        , listDirectory )
import Data.Time
import Data.Time.Clock.POSIX

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

main :: IO ()
main = do
  fs' <- listDirectory "."
  fs <- filterM (\n -> liftM2 (||) (doesFileExist n) (doesDirectoryExist n)) fs'
  fsE <- mapM fileHelper fs
  mapM_ (putStrLn . (\n -> mkRow (n, True))) fsE 
  where
    mkRow :: (Either FolderName File, Bool) -> String
    mkRow ((Left fd), _) = fd
    mkRow ((Right (File sz nm t)), _) = 
      nm ++ " " ++ prettyShow sz ++ " " ++ formatTime defaultTimeLocale "%d-%b-%Y %X" t

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
