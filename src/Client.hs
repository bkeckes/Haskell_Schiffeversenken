module Client1 where

import Network
import Data.Char (toLower)
import Text.Regex.Posix ((=~))
import System.IO (hGetLine,hClose,hPutStrLn,hSetBuffering,BufferMode(..),Handle,stdout)
 
port = 8001 

-- liesst eine IP-Addresse
readIp = untilM (=~ "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}")
        (putStr "Enter IP address: " >> getLine)
 
-- monadic `until`
untilM p x = x >>= (\y -> if p y then return y else untilM p x) 
-- wiederholt beide Aktionen bis eine erfŸllt ist
while2 x y = ifM x (return ()) $ ifM y (return ()) $ while2 x y 
-- monadic `if`
ifM p t f  = p >>= (\p' -> if p' then t else f)

-- client
client = do
        ip <- readIp
        putStrLn "Connecting..."
        h <- connectTo ip (PortNumber port)
        putStrLn $ "Connected to " ++ ip ++ ":" ++ show port
        hSetBuffering h LineBuffering
        while2 (send h) (receive h)
        hClose h

 
-- sending
send h = do
        putStr "Insert coordinates: "
        input <- getLine
        hPutStrLn h input
        return $ null input
 
-- receiving
receive h = do
        putStr "Receiving: "
        input <- hGetLine h
        putStrLn input
        return $ null input
        
--Koordinaten an GUI senden (vom Handler empfangen)

printCoord :: Coord -> IO()
printCoord coord = print ("Angriff auf " ++  show coord)     
      

--Koordinaten an GUI senden (vom Handler empfangen)

printCoordDestroyed :: Coord -> Coord -> IO()
printCoordDestroyed coordStart coordEnd = 
                     print ("Zerstoert! " ++ "Koordinaten: von " ++ show coordStart ++ " bis " ++ show coordEnd)     
      
         
--Status an GUI Ÿbertragen (empfangen vom Handler)

printStatus :: Bool -> IO() 
printStatus status =
          if status == True
                     then  print ("Getroffen!")
                     else  print ("Verfehlt!")
