module Main where

import System.IO (hSetBuffering, BufferMode(NoBuffering), stdout)
import Datatypes
import UserInterface

import War
import Server
import Client
import Logic

import qualified Data.Map as M


--type Ship = [(Coord, Status)]

--type MyShips = [Ship]
-- insertStatus :: Coord -> Status -> EnemyField -> EnemyField
-- insertStatus             
           

--enemyField2 = M.fromList[('A',Fail),('B',Hit)]
main :: IO ()
main = do

    putStrLn "Hallo"
    let enemyField4=insertStatus Hit enemyField4 (2,7) 
    if M.lookup (2,8) enemyField3 ==  Just Hit
                then putStrLn "yes"
                else putStrLn "no"
                
        --let myNewShips= shootShip Coords myShips

    -- let myField = generateShips
    -- let enemyField = M.fromList([('A',1),('A',10)])
        -- putStrLn enemyField
        -- Initialisierung
        -- gameLoop myField enemyField sock

        
-- gameLoop gameStatus =
    -- do
                -- Koord einlesen
                -- Schuss Ã¼bertragen
                -- Antwort
                -- let myGS = gameStatus { myField = ...
                              -- ,  
                                                          -- }
                -- printFields gameStatus'
                -- gameLoop gameStatus' 
                
-- Client.client  = erfraegt Ip-Addresse und senden und empfaengt nachrichten

--Server.server = sendet und empfaengt nachrichten

--Client.printCoord = Koordinaten an GUI senden (vom Server empfangen an Client gesendet)

-- Client.printCoordDestroyed = Koordinaten an GUI senden 

-- Client.printStatus = Status an GUI Ÿbertragen 


               
