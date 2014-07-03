module Client where

import Network
import Data.Char (toLower)
import Text.Regex.Posix ((=~))
import System.IO (hGetLine,hClose,hPutStrLn,hSetBuffering,BufferMode(..),Handle,stdout)
import System.Environment
import Datatypes


port = 8001 

-- liesst eine IP-Addresse und ueberprueft die Syntax der IP-Addresse
readIp = untilM (=~ "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}")
        (putStr "Enter IP address: " >> getLine)
-- monadic `until` = so lange bis 
untilM p x = x >>= (\y -> if p y then return y else untilM p x) 
-- wiederholt beide Aktionen bis eine erfuellt ist
while2 x y = ifM x (return ()) $ ifM y (return ()) $ while2 x y 
-- monadic `if`
ifM p t f  = p >>= (\p' -> if p' then t else f)

-- client, stellt Verbindung zum Server her und sendet bzw. empfaengt Nachrichten vom/zum Server
client = do
        ip <- readIp
        putStrLn "Connecting..."
        h <- connectTo ip (PortNumber port)
        putStrLn $ "Connected to " ++ ip ++ ":" ++ show port
        hSetBuffering h LineBuffering
        while2 (sendCoord h) (receive h)
        hClose h
<<<<<<< HEAD
=======
       
>>>>>>> 86fc57a54d75cee87cf7e5732a14aaf7ed9e3bf5
 
-- senden der Koordinaten die auf der Konsole eingegeben wurden an den Server
sendCoord h = do
        putStr "Angriff: Geben Sie die Koordinaten an: "
        input <- getLine
        hPutStrLn h input
        return $ null input
            
-- empfangen
receive h = do
        input <- hGetLine h
        putStrLn input
        return $ null input
              
                  
--Daten vom Server erhalten
receive :: Handle -> IO String
receive status = do
                 input <- hGetLine status
                 return input
                

--Koordinaten an GUI senden (Parameter von War.getCoord holen) 

printCoord :: Coord -> IO()
printCoord coord = print ("Angriff auf " ++  show coord)    

--Status an GUI senden (Parameter von receiveStatus erhalten)
printStatus :: Status -> IO() 
printStatus status =
          if status == Hit 
                     then  print ("Getroffen!")
                     else  print ("Verfehlt!") 
      
--Koordinaten an GUI senden
                   --((Int,Int),(Int,Int))
printCoordDestroyed :: (Coord,Coord) -> IO()
printCoordDestroyed (coordStart,coordEnd) = 
                        print ("Koordinaten: von " ++ show coordStart ++ " bis " ++ show coordEnd)     
