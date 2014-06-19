module War where

import Datatypes
import Data.Char (ord)
import System.Random
import Logic



--ist ein Schiff der Liste komplett gesunken?
isAShipDestroyed::MyShips->Bool
isAShipDestroyed [] = False
isAShipDestroyed (x:[]) = isOneShipDestroyed x
isAShipDestroyed (x:xs) = isOneShipDestroyed x || isAShipDestroyed xs

--gibt Anfang und Ende eines zerstörtem Schiffs zurück
--und setzt Status auf destroyed
setShipToDestroyed::MyShips->(Coord,Coord)
setShipToDestroyed s = getStartAndEnd $ changeStatusToDestroyed $ getDestroyedShip s

--setzt durch Zufall alle Shiffe in das Feld
generateMyShips::MyShips
generateMyShips = generateNewShip [] 5



---------------------------------------------------------
--  Hilfsfunktionen -------------------------------------
---------------------------------------------------------
--Ist das Schiff komplett getroffen? Also auf jeder Kooridinate Status = Hit?
isOneShipDestroyed::Ship -> Bool
isOneShipDestroyed [] = True
isOneShipDestroyed (x:[]) = isCoordHit x
isOneShipDestroyed (x:xs) = (isCoordHit x) && isOneShipDestroyed (xs)

--ist der Status dieser Koordinate Hit?
isCoordHit:: (Coord, Status) -> Bool
isCoordHit (_,s) = if (s==Hit) then True
                               else False

--gib zerstörtes Shiff zurück							   
getDestroyedShip::MyShips->Ship
getDestroyedShip [] = []
getDestroyedShip (x:[]) = if(isOneShipDestroyed x) == True
                            then x
                            else []
getDestroyedShip (x:xs) = if(isOneShipDestroyed x) == True
                           then x
                           else getDestroyedShip xs

--gibt die Start und End Koordinaten eines Shiffs in einem Tupel zurück.
getStartAndEnd::Ship->(Coord,Coord)
getStartAndEnd [] = ((0,0),(0,0))
getStartAndEnd s = (getCoord(head s), getCoord (last s))

--gibt die Koordinaten aus dem Koordinaten-Status Tupel zurück
getCoord::(Coord, Status)->Coord
getCoord (c,_) = c

--Ändert den Status eines Schiffes auf allen Koordinaten auf Destroyed
changeStatusToDestroyed::Ship->Ship
changeStatusToDestroyed [] = []
changeStatusToDestroyed (x:[]) = (changeTupelToDestroyed x):[]
changeStatusToDestroyed (x:xs) = (changeTupelToDestroyed x):changeStatusToDestroyed xs

--Den Status eines Tupels auf Destroyed setzen
changeTupelToDestroyed::(Coord,Status)->(Coord,Status)
changeTupelToDestroyed (c,s) = (c,Destroyed)

generateNewShip::MyShips->Int->MyShips
generateNewShip s i = ((generateRandomCoord i, Fail):[]):s

generateRandomCoord::Int->Coord
generateRandomCoord i = (2,9)

---------------------------------------------------------
--  Ende Hilfsfunktionen --------------------------------
---------------------------------------------------------
							   





--gibt eine zufällige Coordinate aus der Liste zurück
--getRandomCoord::[Coord]->Coord
--getRandomCoord:	g <- getStdGen
--				print $ take 10 (randomRs ('a', 'z') g)

--Diese Funktion erstellt ein Feld mit Status

-- makeField::Char -> Int -> Field -> Field
-- makeField 'A' i l = makeLine' 'A' i l
-- makeField a i l = makeField (getNextChar a) i $ makeLine' a i l



--Diese Funktion erstellt eine Coordinatenliste
-- makeCoordinates::Char -> Int -> [Coord] -> [Coord]
-- makeCoordinates 'A' i l = makeLine 'A' i l
-- makeCoordinates a i l = makeCoordinates (getNextChar a) i $ makeLine a i l

--Diese Funktion erstellt eine Line von Coordinaten
-- makeLine::Char -> Int -> [Coord] -> [Coord]
-- makeLine a 0 c = c
-- makeLine a b c = makeLine a (b-1) ((makeCoord a b):c)

-- makeCoord::Char -> Int -> Coord
-- makeCoord a b = (a,b)

-- getNextChar::Char -> Char
-- getNextChar a = toEnum((ord a)-1)::Char

--Diese Funktion erstellt ein Teil von einem Feld
-- makeLine'::Char -> Int -> Field -> Field
-- makeLine' a 0 c = c
-- makeLine' a b c = makeLine' a (b-1) ((makeFieldValue (makeCoord a b)):c)

-- makeFieldValue :: Coord -> (Coord,Status)
-- makeFieldValue a = (a, None)
