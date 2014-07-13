{-|
Module      : Main 
Description : : Spielablauf
Maintainer  : soulta@hm.edu, lutz6@hm.edu, nasser@hm.edu, keckes@hm.edu

Hier wird der eigentliche Speilablauf implementiert.
-}
module Main where

import System.IO (hSetBuffering, BufferMode(NoBuffering), stdout)
import Datatypes
import UserInterface
import Server
import Client
import War
import Logic

import qualified Data.Map as M
-- | Generieren der eigenen Schiffe.
ships = generateMyShips --[[((fromIntegral 1::Int,fromIntegral 2::Int),Hit),((fromIntegral 1::Int,fromIntegral 3::Int),PartShip),((fromIntegral 5::Int,fromIntegral 3::Int),PartShip)]]--generateMyShips
-- | Eigenes Spielfeld initialisieren.
myfield = initializeField ships
-- | Spielstand Spieler 1 (Client) initialisieren
gameStatusOwn = Game { myField = myfield, Datatypes.enemyField=M.empty, myShips=ships, turn=Me }        --gameLoop gamestatus
-- | Spielstand Spieler 2 (Server) initialisieren
gameStatusEnemy = Game { myField = myfield, Datatypes.enemyField=M.empty, myShips=ships, turn=Enemy }        --gameLoop gamestatus
-- | Gibt an welcher Spieler gerade am Zug ist
myTurn=False
pseudoCoords=(5,3)
fluchtwert :: Coord
fluchtwert=(0,0)
pseudoStatus=Hit
anfang=(1,2)
ende=(1,5)
           
enemyField = M.fromList[((1,1),Fail),((1,5),Hit),((1,10),Destroyed),((9,3),Hit)]

-- | Main Funktion fŸr Spieler 1. Hier wird nur die Funktion gameLoop aufgerufen.(Ist nicht fertig)
main :: IO ()
main = do
    putStrLn "Willkommen bei Hit the Ships!"
    -- | Erfraegt Ip-Addresse und stellt Verbindung mit dem Server her
    Client.client
    gameLoop gameStatusOwn
    
 -- | Main Funktion fŸr Spieler 2. Hier wird nur die Funktion gameLoop aufgerufen. (Ist nicht fertig)
mainServer :: IO ()
mainServer = do
    putStrLn "Willkommen bei Hit the Ships!"
    -- | Akzeptiert Verbindung zum Client
    Server.server
    gameLoop gameStatusEnemy   
    
-- | Diese Funktion ruft sich immer wieder selbst mit dem neuen Spielstand auf.
-- Falls der Spieler an der Reihe ist wird die Funktion myturn aufgerufen. Falls der Gegner an der Reihe ist wird die Funktion notmyturn aufgerufen.
gameLoop :: Game -> IO ()
gameLoop gameStatus = do
    if ((turn gameStatus)==Again )
        then putStrLn("Feld bereits gespielt, bitte nochmal versuchen")
        else putStrLn("Feld noch nicht gespielt")
    
    printHeadLineMyShips
    printField $ myField newGameStatus
    printHeadLineMyShoots
    printField $ Datatypes.enemyField newGameStatus

    gameLoop newGameStatus        
        where   newGameStatus= if ((turn gameStatus)==Me ||(turn gameStatus)==Again  )
                                then myturn gameStatus
                                else notmyturn gameStatus coords
                                  where   coords= if ((turn gameStatus)==Enemy  )
                                                        then pseudoCoords --getCoordinates 
                                                        else fluchtwert
        
    
-- | Wird augerufen, falls der Spieler an der Reihe ist. Dieser Funktion wird der aktuelle Spielstand ?bergeben.
-- Diesen gibt Sie dann aktualisiert wieder zur?ck. Ablauf wird in der Grafik n?her erleutert.
myturn :: Game->Game
myturn gameStatus=if (coordIsPlayed pseudoC (Datatypes.enemyField gameStatus))
                                          then Game {myField =  (myField gameStatus), Datatypes.enemyField=(Datatypes.enemyField gameStatus), myShips=  (myShips gameStatus),turn=Again}
                                          else if pseudoS==Destroyed
                              then Game { myField =  (myField gameStatus), Datatypes.enemyField=(insertStatuus (anfangK,endeK) Destroyed $Datatypes.enemyField gameStatus), myShips=  (myShips gameStatus),turn=Enemy}
                                                          else Game { myField =  (myField gameStatus), Datatypes.enemyField=(insertStatus pseudoS (Datatypes.enemyField gameStatus) pseudoC), myShips= (myShips gameStatus), turn=Enemy}
                                                          where    
                                                                pseudoS= pseudoStatus --Client.getStatus  --Status der empfangen wurde
                                                                pseudoC= pseudoCoords --getCoordinates --Koordinaten die eingelesen wurden
                                                                anfangK = if pseudoS==Destroyed
                                                                                        then anfang --Server.receiveCoord--anfang --aus Netzwerk
                                                                                        else fluchtwert
                                                                endeK = if pseudoS==Destroyed
                                                                                        then ende --Server.receiveCoord--ende --aus Netzwerk
                                                                                        else fluchtwert
                                                                h=if coordIsPlayed pseudoC (Datatypes.enemyField gameStatus)
                                                                        then print("Koordinate wurde schon gespielt, bitte nochmal")
                                                                        else print("yees")
                                                                        

-- | Wird augerufen, falls der Genger an der Reihe ist. Dieser Funktion wird der aktuelle Spielstand ?bergeben.
-- Diesen gibt Sie dann aktualisiert wieder zur?ck. Ablauf wird in der Grafik n?her erleutert. 
notmyturn :: Game->Coord->Game
notmyturn gameStatus coords=if(isHit coords (myShips gameStatus))
                                then if isAShipDestroyed newShips 
                                         then Game{myField =  (insertStatuus  (getCoordsFromDestroyed newShips) Destroyed (myField gameStatus)), Datatypes.enemyField=(Datatypes.enemyField gameStatus), myShips=  (myShips gameStatus),turn=Me}
                                         else Game{myField =  (insertStatus Hit (myField gameStatus) coords), Datatypes.enemyField=(Datatypes.enemyField gameStatus), myShips=  (myShips gameStatus),turn=Me}
                                else Game{myField =  (insertStatus Fail (myField gameStatus) coords), Datatypes.enemyField=(Datatypes.enemyField gameStatus), myShips=  (myShips gameStatus),turn=Me}
                                                           where newShips = shootField coords (myShips gameStatus)



               


