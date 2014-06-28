module Server2 where

import Network
import Data.Char (toLower)
import Text.Regex.Posix ((=~))
import System.IO (hGetLine,hClose,hPutStrLn,hSetBuffering,BufferMode(..),Handle,stdout)
 
port = 8001 -- a nice port number
 
-- reads in an ip address
readIp = untilM (=~ "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}")
        (putStr "Enter IP address: " >> getLine)
 
-- monadic `until`
untilM p x = x >>= (\y -> if p y then return y else untilM p x) 
-- repeats two actions until either returns true
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
        
--Senden von Koordinaten (handler)


--Senden von Status an Client (handler)


--Senden von Start-und Endkoordinaten (handler)       
