{-# LANGUAGE OverloadedStrings #-}

import CMark
import qualified Data.Text.IO as TO
import qualified Data.Text as T


main :: IO ()
main = do
  content <- TO.readFile "index.md"
  let html_out = T.concat [ "<html>"
                          , "<head>"
                          , "<meta charset=\"utf-8\">"
                          , "<link rel=\"shortcut icon\" type=\"image/png\" href=\"/images/haskell_yb.png\">"
                          , "</head>"
                          , "<body>"
                          , commonmarkToHtml [] content
                          , "</body>"
                          , "</html>"]
  TO.putStrLn html_out
--  TO.writeFile "index.html" html_out
