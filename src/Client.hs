module Client where

import Network
import Data.Char (toLower)
import Text.Regex.Posix ((=~))
import System.IO (hGetLine,hClose,hPutStrLn,hSetBuffering,BufferMode(..),Handle,stdout)
import System.Environment
import Datatypes
 
port = 8001 

-- liesst eine IP-Addresse
readIp = untilM (=~ "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}")
        (putStr "Enter IP address: " >> getLine)
 
-- monadic `until`
untilM p x = x >>= (\y -> if p y then return y else untilM p x) 
-- wiederholt beide Aktionen bis eine erfÙllt ist
while2 x y = ifM x (return ()) $ ifM y (return ()) $ while2 x y 
-- monadic `if`
ifM p t f  = p >>= (\p' -> if p' then t else f)

-- client , stellt Verbindung zum Server her und sendet bzw. empfaengt Nachrichten vom/zum Server
client = do
        ip <- readIp
        putStrLn "Connecting..."
        h <- connectTo ip (PortNumber port)
        putStrLn $ "Connected to " ++ ip ++ ":" ++ show port
        hSetBuffering h LineBuffering
       -- while2 (sendCoord h) (receive h)
       -- hClose h
 
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
        
--Koordinaten vom Server erhalten
receiveCoord :: Handle -> IO String
receiveCoord coord = do
                 input <- hGetLine coord
                 return input
        
--Status vom Server erhalten
receiveStatus ::  Handle -> IO Bool 
receiveStatus status = do
                 input <- hGetLine status
                 return $ null input      

        
--Koordinaten an GUI senden (vom Handler empfangen)

printCoord :: Coord -> IO()
printCoord coord = print ("Angriff auf " ++  show coord)     
      

--Koordinaten an GUI senden (vom Handler empfangen)

printCoordDestroyed :: Coord -> Coord -> IO()
printCoordDestroyed coordStart coordEnd = 
                     print ("Zerstoert! " ++ "Koordinaten: von " ++ show coordStart ++ " bis " ++ show coordEnd)     
      
         
--Status an GUI uebertragen (empfangen vom Handler)

printStatus :: Bool -> IO() 
printStatus status =
          if status == True
                     then  print ("Getroffen!")
                     else  print ("Verfehlt!")