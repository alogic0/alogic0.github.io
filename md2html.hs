{-# LANGUAGE OverloadedStrings #-}

import CMark
import qualified Data.Text.IO as TO
import qualified Data.Text as T


main :: IO ()
main = do
  content <- TO.readFile "index.md"
  let header = 
        T.unlines 
          [ "<html>"
          , "<head>"
          , "<meta charset=\"utf-8\">"
          , "<link rel=\"shortcut icon\" type=\"image/png\" href=\"/images/lambda_yb.png\">"
          , "</head>"
          , "<body>" ]
  let footer =
        T.unlines 
          [ "</body>"
          , "</html>"]
  TO.putStrLn $ T.concat
                  [ header
                  , commonmarkToHtml [] content
                  , footer]
--  TO.writeFile "index.html" html_out
