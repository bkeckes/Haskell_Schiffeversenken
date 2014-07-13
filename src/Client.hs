{-|
Module      : Client
Description : : Kommunikation auf der Clientseite 
Maintainer  : lutz6@hm.edu

Hier wird die Kommunikation mit dem Server aufgebaut und Spieldaten von Server zu Client (Gegner) und umgekehrt geschickt.
-}

module Client where

import Network
import Data.Char (toLower)
import Text.Regex.Posix ((=~))
import System.IO (hGetLine,hClose,hPutStrLn,hSetBuffering,BufferMode(..),Handle,stdout)
import System.Environment
import Datatypes
 
port = 8001 

-- | Liesst eine IP-Addresse und ueberprueft die Syntax der IP-Addresse
readIp = untilM (=~ "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}")
        (putStr "Enter IP address: " >> getLine)
-- | monadic `until` = so lange bis 
untilM p x = x >>= (\y -> if p y then return y else untilM p x) 
-- | wiederholt beide Aktionen bis eine erfuellt ist
while2 x y = ifM x (return ()) $ ifM y (return ()) $ while2 x y 
-- | monadic `if`
ifM p t f  = p >>= (\p' -> if p' then t else f)

-- | Client, stellt Verbindung zum Server her und sendet bzw. empfaengt Nachrichten vom/zum Server
client = do
        ip <- readIp
        putStrLn "Connecting..."
        h <- connectTo ip (PortNumber port)
        putStrLn $ "Connected to " ++ ip ++ ":" ++ show port
        hSetBuffering h LineBuffering
        while2 (sendCoordToServer h) (receive h);
        hClose h

             
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
          
              
-- | Senden der Koordinaten die auf der Konsole eingegeben wurden an den Server
sendCoordToServer h = do
        putStr "Angriff: Geben Sie die Koordinaten an: "
        input <- getLine
        hPutStrLn h input
        return $ null input             
                          
-- | Status vom Server erhalten
receiveStatus :: Handle -> IO String
receiveStatus h = do
        input <- hGetLine h
        return input
 
-- | Umwandeln vom Status aus receiveStatus in richtiges Format 
getStatus :: Monad m => [Char] -> m Status
getStatus status =  do
  if status == "Hit"
        then return Hit
        else return Fail
                
-- | Koordinaten an GUI senden (Parameter von War.getCoord holen) 
printCoord :: Coord -> IO()
printCoord coord = print ("Angriff auf " ++  show coord)    

-- | Status an GUI senden (Parameter von receiveStatus erhalten)
printStatus :: Status -> IO() 
printStatus status =
          if status == Hit 
                     then  print ("Getroffen!")
                     else  print ("Verfehlt!") 
      
-- | Koordinaten an GUI senden
                   --((Int,Int),(Int,Int))
printCoordDestroyed :: (Coord,Coord) -> IO()
printCoordDestroyed (coordStart,coordEnd) = 
                        print ("Koordinaten: von " ++ show coordStart ++ " bis " ++ show coordEnd)     
