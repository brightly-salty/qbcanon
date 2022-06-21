--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           System.FilePath
import           Data.List (isSuffixOf)

--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith (defaultConfiguration {destinationDirectory = "docs"}) $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.md", "contribute.md"]) $ do
        route   cleanRoute
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls
            >>= cleanIndexUrls

    match ("science.md" .||. "science/*.md" .||. "arts-humanities.md" .||. "arts-humanities/*.md" .||. "literature.md"  .||. "literature/*.md" .||. "history.md" .||. "history/*.md") $ do
        route  cleanRoute
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls 
            >>= cleanIndexUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            getResourceBody
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls
                >>= cleanIndexUrls

    match "templates/*" $ compile templateBodyCompiler

cleanRoute :: Routes
cleanRoute = customRoute ((\p -> takeDirectory p </> takeBaseName p </> "index.html") . toFilePath)

cleanIndexUrls :: Item String -> Compiler (Item String)
cleanIndexUrls = pure . fmap (withUrls cleanIndex)

cleanIndex :: String -> String
cleanIndex url
  | "index.html" `isSuffixOf` url = take (length url - 10) url
  | otherwise = url