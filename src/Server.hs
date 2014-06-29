module Server where

import Network
import Data.Char (toLower)
import Text.Regex.Posix ((=~))
import System.IO (hGetLine,hClose,hPutStrLn,hSetBuffering,BufferMode(..),Handle,stdout)
import System.Environment
import Datatypes
import Logic

port = 8001 
 
-- monadic `until`
untilM p x = x >>= (\y -> if p y then return y else untilM p x) 
-- wiederholt beide Aktionen bis eine erfŸllt ist
while2 x y = ifM x (return ()) $ ifM y (return ()) $ while2 x y 
-- monadic `if`
ifM p t f  = p >>= (\p' -> if p' then t else f)

-- server
server = do
        sock <- listenOn (PortNumber port)
        putStrLn "Awaiting connection."
        (h,host,port) <- accept sock
        putStrLn $ "Received connection from " ++ host ++ ":" ++ show port
        hSetBuffering h LineBuffering
        while2 (receive h) (send h)
        hClose h
        sClose sock
 
-- sending
send h = do
        input <- getLine
        hPutStrLn h input
        return $ null input
 
-- receiving
receive h = do
        input <- hGetLine h
        putStrLn input
        return $ null input
        
--Koordinaten vom Client erhalten
receiveCoord :: Handle -> IO String
receiveCoord coord = do
                 input <- hGetLine coord
                 return input
        
--Status vom Client erhalten
receiveStatus ::  Handle -> IO Bool 
receiveStatus status = do
                 input <- hGetLine status
                 return $ null input   
        
--Senden von Koordinaten (handler)
sendCoord :: Handle -> IO String
sendCoord coord = do
              input <- getLine
              return input

--Senden von Status an Client (handler)
sendStatus :: Handle -> IO Bool
sendStatus status = do
              input <- getLine
              return $ null input

--Senden von Start-und Endkoordinaten (handler)       
--sendStartAndEndCoord :: Handle -> (Coord, Coord) -> IO String
--sendStartAndEndCoord coord = do
--                 input <- getLine
--                 return input