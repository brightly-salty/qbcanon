--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           System.FilePath
import           Data.List (isSuffixOf)
import           Text.Pandoc.Options
import qualified Text.Pandoc.Templates as TP
import           Data.String (IsString)
import           Data.Functor.Identity (runIdentity)
import           Data.Text (Text)

--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith (defaultConfiguration {inMemoryCache = False}) $ do
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

    match ("science.md" .||. "science/*.md" .||. "science/**/*.md") $ do
        route  cleanRoute
        compile $ do
            underlying <- getUnderlying
            toc <- getMetadataField underlying "tableOfContents"
            let writerOptions' = maybe defaultHakyllWriterOptions (const withTOC) toc
            pandocCompilerWith defaultHakyllReaderOptions writerOptions'
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls 
                >>= cleanIndexUrls

    match ("literature.md" .||. "literature/*.md" .||. "literature/**/*.md") $ do
        route  cleanRoute
        compile $ do
            underlying <- getUnderlying
            toc <- getMetadataField underlying "tableOfContents"
            let writerOptions' = maybe defaultHakyllWriterOptions (const withTOC) toc
            pandocCompilerWith defaultHakyllReaderOptions writerOptions'
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls 
                >>= cleanIndexUrls

    match ("arts-humanities.md" .||. "arts-humanities/*.md" .||. "arts-humanities/**/*.md") $ do
        route  cleanRoute
        compile $ do
            underlying <- getUnderlying
            toc <- getMetadataField underlying "tableOfContents"
            let writerOptions' = maybe defaultHakyllWriterOptions (const withTOC) toc
            pandocCompilerWith defaultHakyllReaderOptions writerOptions'
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls 
                >>= cleanIndexUrls
                
    match ("history.md" .||. "history/*.md" .||. "history/**/*.md") $ do
        route  cleanRoute
        compile $ do
            underlying <- getUnderlying
            toc <- getMetadataField underlying "tableOfContents"
            let writerOptions' = maybe defaultHakyllWriterOptions (const withTOC) toc
            pandocCompilerWith defaultHakyllReaderOptions writerOptions'
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

withTOC :: WriterOptions
withTOC = defaultHakyllWriterOptions
        {
            writerNumberSections = False,
            writerTableOfContents = True,
            writerTOCDepth = 4,
            writerTemplate = Just tocTemplate
        }

tocTemplate :: TP.Template Text
tocTemplate = either error id $ runIdentity $ TP.compileTemplate "" "<div class='toc'><div class='header'>Table of Contents</div>\n$toc$\n</div>\n$body$"