module Main where

import System.IO (hSetBuffering, BufferMode(NoBuffering), stdout)
import Datatypes
import UserInterface
import Server
import Client
import War
import Logic

import qualified Data.Map as M

ships = generateMyShips
myfield = initializeField ships
gameStatus = Game { myField = myfield, enemyField=M.empty, myShips=ships }	--gameLoop gamestatus
myTurn=True
pseudoCoords=(8,7)
pseudoStatus=Hit--Destroyed
anfang=(1,2)
ende=(1,5)
fluchtwert=(-1,-1)
           
--enemyField = M.fromList[((1,1),Fail),((1,5),Hit),((1,10),Destroyed),((9,3),Hit)]

main :: IO ()
main = do
    putStrLn "Willkommen bei Hit the Ships!"
    -- Client.client  = erfraegt Ip-Addresse und stellt Verbindung mit Server her
    --Client.client
    gameLoop gameStatus
    --Feld Spieler 1 initialisieren
    
    --Feld Spieler 2 initialisieren

gameLoop :: Game -> IO ()
gameLoop gameStatus = do
    printMyField $ myField newGameStatus
    printMyField $ enemyField newGameStatus
	where    newGameStatus= if myTurn
                                then myturn gameStatus
                                else notmyturn gameStatus
	
	--gameLoop newGameStatus	
    
    
myturn :: Game->Game
myturn gameStatus=if pseudoS==Destroyed
                      then Game { myField =  (myField gameStatus), enemyField=(insertStatuus anfangK endeK Destroyed $enemyField gameStatus), myShips=  (myShips gameStatus)}
                      else Game { myField =  (myField gameStatus), enemyField=(insertStatus pseudoS (enemyField gameStatus) pseudoC), myShips= (myShips gameStatus)}
						where    
							pseudoS=pseudoStatus  --Status der empfangen wurde
							pseudoC = pseudoCoords  --Koordinaten die eingelesen wurden
							anfangK = if pseudoS==Destroyed
										then anfang --aus Netzwerk
										else fluchtwert
							endeK = if pseudoS==Destroyed
									    then ende --aus Netzwerk
										else fluchtwert
    
notmyturn :: Game->Game
notmyturn gameStatus=gameStatus
    
    --if myTurn
      --  then --Koords einlesen
             --In ship array enthalten-> coordIsPlayed von Logic.hs
			 --Senden
			 --Status empfangen
        --    newEnemyField = if pseudoStatus==Destroyed
          --      then    --Anfang/Eckpunkt empfangen
            --            insertStatuus anfang ende Destroyed $enemyField gameStatus
                        --printMyField $ myField gameStatus
                        --printMyField newEnemyField
                       -- newGameStatus = Game { myField = $ myField gameStatus, enemyField=newEnemyField, myShips= $ ships gameStatus}
                -- gameLoop newGameStatus
              --  else	
				--	insertStatus pseudoCoords (enemyField gameStatus) pseudoCoords
        --     printMyField $ myField gameStatus
          --   printMyField newEnemyField
           --  newGameStatus = Game { myField = $ myField gameStatus, enemyField=newEnemyField, myShips= $ ships gameStatus}
         --else
          --   printMyField $ myField gameStatus
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

        

                




-- Client.printCoord = Koordinaten an GUI senden (vom Server empfangen an Client gesendet)

-- Client.printCoordDestroyed = Koordinaten an GUI senden 

-- Client.printStatus = Status an GUI Ÿbertragen 


               
