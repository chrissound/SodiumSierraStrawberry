{-# LANGUAGE OverloadedStrings #-}
module Prompt where

import Options.Applicative
import Control.Monad (join)
import Data.Monoid ((<>))
import Data.List.Split (splitOn)
import Data.List (intercalate)
import Data.Maybe
import System.Directory
import Data.Aeson
import Data.List (sort)
-- import Text.Pretty.Simple (pPrint)
import Data.String.Utils (startswith)
import Safe
import Data.Bool

type Path = String

main :: IO ()
main = join . customExecParser (prefs showHelpOnError) $
  info (helper <*> parser)
  (  fullDesc
  <> header "list directories"
  )
  where
    parser :: Parser (IO ())
    parser =
      work
        <$> argument str
            (  metavar "STRING"
            <> help "string parameter"
            )
        <*> option auto
            (  long "limit"
            <> short 'l'
            <> metavar "INT"
            <> help "number parameter"
            <> value 0
            <> showDefault
            )

getShort :: String -> String
getShort "" = ""
getShort path = concatMap
  (\x ->
     if ((length x) > 3) && (not $ elem '»' x)
     then (take 3 x ++ "…/")
     else (x ++ "/")
  )
  $ splitOn "/" path

iteration :: String -> String -> String
iteration x y = getShort x ++ y

joinBy :: [path] -> [[path]] -> [path]
joinBy sep cont = drop (length sep) $ concat $ map (\w -> sep ++ w) cont

zipLeftover :: [path] -> [path] -> [path]
zipLeftover []     []     = []
zipLeftover xs     []     = xs
zipLeftover []     ys     = ys
zipLeftover (_:xs) (_:ys) = zipLeftover xs ys

lastN :: Int -> [path] -> [path]
lastN n xs = zipLeftover (drop n xs) xs

splitAtN :: Int -> [path] -> ([path], [path])
splitAtN n x = (take n x, lastN (length x - n) x)

replaceAtStart :: Eq path => [path] -> [path] -> [path] -> [path]
replaceAtStart old new s = 
  if (startswith old s)
    then intercalate new . splitOn old $ s
    else s

applyAll :: [(path -> path)] -> path -> path
applyAll [] = id
applyAll (f:fs) = applyAll fs . f

readConfig :: IO [(String, String)]
readConfig = do
  x <- getXdgDirectory XdgConfig "sodiumSierraStrawberry"
  (eitherDecodeFileStrict $ x ++ "/config.json") >>= \case
    Right x' -> pure x'
    Left e -> error e

work :: Path -> Int -> IO ()
work path maxLength = do
  c <- (reverse . sort) <$> readConfig
  let dirsList = splitOn "/" $ applyAll ((replaceAtStart <$> fst <*> snd) <$> c) path

  let range = [0 .. (max (length dirsList - 1) 0)]
  let shortened i = iteration (joinBy "/" $ p1) (intercalate "/" p2) where
               (p1,p2) = splitAtN i dirsList

  -- Get the first entry that satifies < maxLength
  let mapped = (\i -> if (length (shortened i) < maxLength) then Just $ shortened i else Nothing) <$> range

  case (catMaybes $ (mapped ++ [Just $ shortened $ last range])) of
    (x:_) -> putStrLn $ appendPossibleTrailingSlash x
    _ -> error "Something went wrong"

appendPossibleTrailingSlash :: String -> String
appendPossibleTrailingSlash x = maybe x (bool (x++"/") x . ((==) '/')) (lastMay x)
