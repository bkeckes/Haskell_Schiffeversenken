module Main where

import System.IO (hSetBuffering, BufferMode(NoBuffering), stdout)
import Datatypes
import UserInterface
import Server
import Client
import War
import Logic

import qualified Data.Map as M

ships = [[((fromIntegral 1::Int,fromIntegral 2::Int),Hit),((fromIntegral 1::Int,fromIntegral 3::Int),PartShip),((fromIntegral 5::Int,fromIntegral 3::Int),PartShip)]]--generateMyShips
myfield = initializeField ships
gameStatus = Game { myField = myfield, enemyField=M.empty, myShips=ships, turn=Enemy }	--gameLoop gamestatus
myTurn=False
pseudoCoords=(5,3)
fluchtwert=(2,2)
pseudoStatus=Hit--Destroyed
anfang=(1,2)
ende=(1,5)
           
--enemyField = M.fromList[((1,1),Fail),((1,5),Hit),((1,10),Destroyed),((9,3),Hit)]

main :: IO ()
main = do
    putStrLn "Willkommen bei Hit the Ships!"
    -- Client.client  = erfraegt Ip-Addresse und stellt Verbindung mit Server her
    --Client.client
    gameLoop gameStatus
 

gameLoop :: Game -> IO ()
gameLoop gameStatus = do
    if ((turn gameStatus)==Again  )
        then putStrLn("Feld bereits gespielt, bitte nochmal versuchen")
        else putStrLn("Feld noch nicht gespielt")
    
    printMyField $ myField newGameStatus
    printMyField $ enemyField newGameStatus
    if isHit pseudoCoords (myShips gameStatus)
		then putStrLn("hit")
		else putStrLn("fail")
   --gameLoop newGameStatus	
	where   newGameStatus= if ((turn gameStatus)==Me ||(turn gameStatus)==Again  )
                                then myturn gameStatus
                                else notmyturn gameStatus coords
                                  where   coords= if ((turn gameStatus)==Enemy  )
	                                                then pseudoCoords
	                                                else fluchtwert
    
    
myturn :: Game->Game
myturn gameStatus=if (coordIsPlayed pseudoC (enemyField gameStatus))
					  then Game {myField =  (myField gameStatus), enemyField=(enemyField gameStatus), myShips=  (myShips gameStatus),turn=Again}
					  else if pseudoS==Destroyed
                              then Game { myField =  (myField gameStatus), enemyField=(insertStatuus (anfangK,endeK) Destroyed $enemyField gameStatus), myShips=  (myShips gameStatus),turn=Enemy}
							  else Game { myField =  (myField gameStatus), enemyField=(insertStatus pseudoS (enemyField gameStatus) pseudoC), myShips= (myShips gameStatus), turn=Enemy}
					          	where    
								pseudoS=pseudoStatus  --Status der empfangen wurde
								pseudoC = pseudoCoords  --Koordinaten die eingelesen wurden
								anfangK = if pseudoS==Destroyed
											then anfang --aus Netzwerk
											else fluchtwert
								endeK = if pseudoS==Destroyed
											then ende --aus Netzwerk
											else fluchtwert
								h=if coordIsPlayed pseudoC (enemyField gameStatus)
									then print("Koordinate wurde schon gespielt, bitte nochmal")
									else print("yees")
									
									
notmyturn :: Game->Coord->Game
notmyturn gameStatus coords=if(isHit coords (myShips gameStatus))
                                then if isAShipDestroyed newShips 
                                         then Game{myField =  (insertStatuus  (setShipToDestroyed newShips) Destroyed (myField gameStatus)), enemyField=(enemyField gameStatus), myShips=  (myShips gameStatus),turn=Me}
                                         else Game{myField =  (insertStatus Hit (myField gameStatus) coords), enemyField=(enemyField gameStatus), myShips=  (myShips gameStatus),turn=Me}
                                else Game{myField =  (insertStatus Fail (myField gameStatus) coords), enemyField=(enemyField gameStatus), myShips=  (myShips gameStatus),turn=Me}
							   where newShips = shootField coords (myShips gameStatus)

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


               
