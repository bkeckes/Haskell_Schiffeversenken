module Main where

import System.IO (hSetBuffering, BufferMode(NoBuffering), stdout)
import Datatypes
import UserInterface
import Server
import War
import Client
import qualified Data.Map as M

            
           
--enemyField = M.fromList[((1,1),Fail),((1,5),Hit),((1,10),Destroyed),((9,3),Hit)]

main :: IO ()
main = do

    putStrLn "Willkommen bei Hit the Ships!"
    -- Client.client  = erfraegt Ip-Addresse und sendet und empfaengt nachrichten
    Client.client


--gameLoop gameStatus = do
                -- Koord einlesen vom Client
                -- Client.send
                -- Schuss Ã¼bertragen an Server und dann weiterleiten an Logic
                -- Server.receiveCoord
                -- Antwort von Logic an Server und dann an den Client weiterleiten
                
                -- let myGS = gameStatus { myField = ...
                              -- ,  
                                                          -- }
                -- printFields gameStatus'
                -- gameLoop gameStatus' 
    
  --  let enemyField4=insertStatus Hit enemyField4 (2,7) 
  --   if M.lookup (2,8) enemyField3 ==  Just Hit
  --             then putStrLn "yes"
  --            else putStrLn "no"
                
        --let myNewShips= shootShip Coords myShips

    -- let myField = generateShips
    -- let enemyField = M.fromList([('A',1),('A',10)])
        -- putStrLn enemyField
        -- Initialisierung
        -- gameLoop myField enemyField sock

        

                




--Client.printCoord = Koordinaten an GUI senden (vom Server empfangen an Client gesendet)

-- Client.printCoordDestroyed = Koordinaten an GUI senden 

-- Client.printStatus = Status an GUI Ÿbertragen 


               
