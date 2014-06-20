module Client where

import Network.Socket
import Control.Exception
import Datatypes

port = "3000"

main = withSocketsDo $ bracket getSocket sClose talk
        where getSocket = do
                (serveraddr:_) <- getAddrInfo Nothing (Just "127.0.0.1") (Just port)
                s <- socket (addrFamily serveraddr) Datagram defaultProtocol
                connect s (addrAddress serveraddr) >> return s
              talk s = do
                putStrLn $ "Welcome to Hit the Ships! \n Geben Sie Ihren Gegenspieler an: "
               
                --IP-Adresse des Gegners eingeben und an Server senden.
                ipaddresse <- getLine
                send s ipaddresse
                putStrLn $ "Ihr Gegner ist:  " ++ ipaddresse ++ "."
     

--Koordinaten empfangen von der GUI und an den Handler weiterleiten

getCoord :: IO Coord
getCoord  = 
      do 
          coord <- getLine
          return (read coord :: Coord)

--Koordinaten und Status an GUI senden (vom Handler empfangen)

sendCoordDestroyed :: Coord -> Coord -> IO()
sendCoordDestroyed coordStart coordEnd = 
                     print ("Zerstoert " ++ "Koordinaten: von " ++ show coordStart ++ " bis " ++ show coordEnd)     
      
         
--Status an beide Spieler Ÿbertragen (empfangen vom Handler)

sendStatus :: Status -> IO() 
sendStatus status =
          if status == Hit
                     then  print ("Getroffen!")
                     else 
          if  status == Fail
                     then print ("Nicht getroffen!")
                     else print ("Error")

--Spielergebnis an beide Spieler Ÿbertragen (empfagenen vom Handler)     

--sendGameResult :: Status -> IO()
--sendGameResult status = 