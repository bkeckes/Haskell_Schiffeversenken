{-|
Module : Server
Description : : Kommunikation Serverseite
Maintainer : lutz6@hm.edu

Hier wird die Verbindung zum Client akzeptiert und eine Verbindung aufgebaut.
Hier findet die Kommunikation von der Logic Ÿber den Server zum Client statt.
-}

module Server where

import Network
import Data.Char (toLower)
import Text.Regex.Posix ((=~))
import System.IO (hGetLine,hClose,hPutStrLn,hSetBuffering,BufferMode(..),Handle,stdout)
import System.Environment
import Datatypes
import Logic

port = 8001
 
-- | monadic `until`
untilM p x = x >>= (\y -> if p y then return y else untilM p x)
-- | wiederholt beide Aktionen bis eine erfÙllt ist
while2 x y = ifM x (return ()) $ ifM y (return ()) $ while2 x y
-- | monadic `if`
ifM p t f = p >>= (\p' -> if p' then t else f)

myTurn = False

-- | server
server = do
        sock <- listenOn (PortNumber port)
        putStrLn "Awaiting connection."
        (h,host,port) <- accept sock
        putStrLn $ "Received connection from " ++ host ++ ":" ++ show port
        hSetBuffering h LineBuffering
        while2 (receive h) (send h) 
        hClose h
        sClose sock
 
-- | senden
send h = do
        input <- getLine
        hPutStrLn h input
        return $ null input
 
-- | empfangen
receive h = do
        input <- hGetLine h
        putStrLn input
        return $ null input
  
-- | Koordinaten vom Client (Console) erhalten
receiveCoord :: Handle -> Handle -> IO (String, String)
receiveCoord coord1 coord2 = do
        putStrLn $ "Angriff auf : "
        input1 <- hGetLine coord1
        input2 <- hGetLine coord2
        return (input1,input2)

-- | Wandelt die Coordinaten von receiveCoord in richtiges Format um
getCoordinates :: (String, String) -> (Int, Int)
getCoordinates (input1,input2) = ((read input1 :: Int), (read input2 :: Int))

                        
-- | RŸckgabe der Koordinaten die auf der Konsole im Server eingegeben wurden
sendCoordToClient :: Handle -> IO Bool
sendCoordToClient h = do
        putStr "Gegenangriff: Geben Sie die Koordinaten an: "
        input <- getLine
        hPutStrLn h input
        return $ null input                       

-- | Senden von Status an Client 
sendStatus :: Status -> IO String
sendStatus status = do
              status <- getLine
              return status

-- | Senden von Start-und Endkoordinaten 
sendStartAndEndCoord ::(Coord, Coord) -> IO String
sendStartAndEndCoord coord = do
                 coord <- getLine
                 return coord