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
-- wiederholt beide Aktionen bis eine erfÙllt ist
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
            
--Status vom Client erhalten
receiveStatus :: Handle -> IO String
receiveStatus status = do
                 input <- hGetLine status
                 return input
                 
parseTyp :: String -> Status
parseTyp status = 
       |status = "" = Nothing
       |status = "fail" = Fail
       |status = "hit" = Hit
       |status =  "destroyed" = Destroyed
       |otherwise = Error   
               
--Senden von Koordinaten (handler)
sendCoord :: Coord -> IO String
sendCoord coord = do
              coord <- getLine
              return coord

--Senden von Status an Client (handler)
sendStatus :: Status -> IO String
sendStatus status = do
              status <- getLine
              return status

--Senden von Start-und Endkoordinaten (handler)       
sendStartAndEndCoord ::(Coord, Coord) -> IO String
sendStartAndEndCoord coord = do
                 coord <- getLine
                 return coord