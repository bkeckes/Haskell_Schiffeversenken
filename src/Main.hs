module Main where

import System.IO (hSetBuffering, BufferMode(NoBuffering), stdout)

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    putStr $ "Hallo"

