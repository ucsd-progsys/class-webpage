--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Hakyll
import Text.Pandoc

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  match "static/*/*" $ do
    route idRoute
    compile copyFileCompiler
    match (fromList tops {- ["about.md", "contact.markdown"] -}) $ do
          route   $ setExtension "html"
          compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html"    siteCtx
            >>= loadAndApplyTemplate "templates/default.html" siteCtx
            >>= relativizeUrls

    match "lectures/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    {-

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    siteCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls
    -} 

    match "orig-index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    siteCtx

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    siteCtx

siteCtx :: Context String
siteCtx =
    constField "baseurl"            "http://localhost:8000"     `mappend`
    constField "site_name"          "cse131"                    `mappend`
    constField "site_description"   "UCSD CSE 131"              `mappend`
    -- constField "instagram_username" "ranjitjhala"               `mappend`
    constField "site_username"      "Ranjit Jhala"              `mappend`
    constField "twitter_username"   "ranjitjhala"               `mappend`
    constField "github_username"    "ranjitjhala"               `mappend`
    constField "google_username"    "rjhala@eng.ucsd.edu"       `mappend`
    constField "google_userid"      "u/0/106612421534244742464" `mappend`
    constField "piazza_classid"     "ucsd/fall2016/cse131/home" `mappend`
    defaultContext


tops =
  [ "index.markdown"
  , "grades.markdown"
  , "lectures.markdown"
  , "links.markdown"
  , "assignments.markdown"
  , "calendar.markdown"
  , "contact.markdown"
  ]
