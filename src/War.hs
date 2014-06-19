module War where

import Datatypes
import Data.Char (ord)
import System.Random
import Logic



--ist ein Schiff der Liste komplett gesunken?
isAShipDestroyed::MyShips->Bool
isAShipDestroyed [] = False
isAShipDestroyed (x:[]) = isAllHit x
isAShipDestroyed (x:xs) = isAllHit x || isAShipDestroyed xs

--gibt Anfang und Ende eines zerstörtem Schiffs zurück
--und setzt Status auf destroyed
setShipToDestroyed::MyShips->(Coord,Coord)


--setzt durch Zufall alle Shiffe in das Feld
--insertShips::MyShips->MyShips


---------------------------------------------------------
--  Hilfsfunktionen -------------------------------------
---------------------------------------------------------
--Ist das Schiff komplett getroffen? Also auf jeder Kooridinate Status = Hit?
isAllHit::Ship -> Bool
isAllHit [] = True
isAllHit (x:[]) = isCoordHit x
isAllHit (x:xs) = (isCoordHit x) && isAllHit (xs)

--ist der Status dieser Koordinate Hit?
isCoordHit:: (Coord, Status) -> Bool
isCoordHit (_,s) = if (s==Hit) then True
                               else False
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
