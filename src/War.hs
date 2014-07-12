module War where

import Datatypes
import Data.Char (ord)
import System.Random
import Logic

import System.IO.Unsafe
import Data.Time.Clock.POSIX
import System.Random
import System.Time (getClockTime, ClockTime(TOD))




-- | ist ein Schiff der Liste komplett gesunken?
isAShipDestroyed::MyShips->Bool
isAShipDestroyed (x:[]) = (hasShipState Hit x)
isAShipDestroyed (x:xs) = (hasShipState Hit x) || (isAShipDestroyed xs)

-- | gibt Anfang und Ende eines zerstörten Schiffs zurück
getCoordsFromDestroyed::MyShips->(Coord,Coord)
getCoordsFromDestroyed ships = getStartAndEnd $ getShipWithState Hit ships

-- | setzt den Status aller Felder des getroffenen Schiffes auf Destroyed
setShipToDestroyed::MyShips->MyShips
setShipToDestroyed ships = changeShip ships $ changeStatusToDestroyed $ getShipWithState Hit ships

-- | setzt durch Zufall alle Shiffe in das Feld
generateMyShips::MyShips
generateMyShips = generateNewShip 0 2 $ 
                  generateNewShip 0 2 $ 
                  generateNewShip 0 3 $ 
                  generateNewShip 0 3 $ 
                  generateNewShip 0 3 $ 
                  generateNewShip 0 4 $ 
                  generateNewShip 0 4 $ 
                  generateNewShip 0 5 []


---------------------------------------------------------
-- Hilfsfunktionen -------------------------------------
---------------------------------------------------------

-- | Tauscht das Schiff in der Liste aus
changeShip::MyShips->Ship->MyShips
changeShip [] _ = []
changeShip ships [] = ships
changeShip (x:[]) s = if(isSameShip x s)
                       then s:[]
                       else x:[]
changeShip (x:xs) s = if(isSameShip x s)
                       then s:xs
                       else x : ( changeShip xs s )

-- | Vergleicht zwei Schiffe miteinander
isSameShip::Ship->Ship->Bool
isSameShip _ [] = False
isSameShip [] _ = False
isSameShip (x:[]) (y:[]) = isSameCoord x y
isSameShip (x:xs) (y:ys) = isSameCoord x y && (isSameShip xs ys)

-- | Vergleicht Koordinaten
isSameCoord::(Coord,Status)->(Coord,Status)->Bool
isSameCoord (a,_) (b,_) = a==b


-- | Hat das Schiff in allen Teilen den angeforderten Status?
hasShipState::Status->Ship->Bool
hasShipState _ [] = False
hasShipState state (x:[]) = hasCoordState state x
hasShipState state (x:xs) = (hasCoordState state x) && (hasShipState state xs)

-- | ist der Status dieser Koordinate wie gefordert?
hasCoordState::Status->(Coord, Status) -> Bool
hasCoordState state (_,s) = (s==state)

-- | gib zerstörtes Shiff zurück
getShipWithState::Status->MyShips->Ship
getShipWithState _ [] = []
getShipWithState state (x:xs) = if(hasShipState state x) == True
                           then x
                           else getShipWithState state xs


-- | gibt die Start- und Endkoordinaten eines Shiffs in einem Tupel zurück.
getStartAndEnd::Ship->(Coord,Coord)
getStartAndEnd [] = ((0,0),(0,0))
getStartAndEnd s = (getCoord(head s), getCoord (last s))

-- | gibt die Koordinaten aus dem Koordinaten-Status Tupel zurück
getCoord::(Coord, Status)->Coord
getCoord (c,_) = c

-- | Ändert den Status eines Schiffes auf allen Koordinaten auf Destroyed
changeStatusToDestroyed::Ship->Ship
changeStatusToDestroyed [] = []
changeStatusToDestroyed (x:[]) = (changeTupelToDestroyed x):[]
changeStatusToDestroyed (x:xs) = (changeTupelToDestroyed x):changeStatusToDestroyed xs

-- | Den Status eines Tupels auf Destroyed setzen
changeTupelToDestroyed::(Coord,Status)->(Coord,Status)
changeTupelToDestroyed (c,_) = (c,Destroyed)


-- | Es wird ein neues Schiff in die Liste eingefügt. Dann wird die Liste zurück gegeben
generateNewShip::Int->Int->MyShips->MyShips
generateNewShip salt laenge feld = if (neuesFeld == feld)
                            then generateNewShip (salt+1) laenge feld
                            else neuesFeld
                            where neuesFeld = (insertShip (getShip salt laenge) feld)
                                          


-- | Ein Schiff wird in die Liste eingefügt, wenn es kein anderes Schiff überlappt
insertShip::Ship->MyShips->MyShips
insertShip n s = if ((isCoordTaken n (makeOneList s []))) == False
                         then n : s
                         else s

-- | Es wird eine lange Liste aus allen Schiffen erstellt
makeOneList::MyShips->[(Coord,Status)]->[(Coord,Status)]
makeOneList [] l = l
makeOneList (x:[]) l = l ++ x
makeOneList (x:xs) l = (makeOneList xs l) ++ x

-- | Sind alle Teile eines Schiffs innerhalb der Koordinaten
isShipInField::Ship->Bool
isShipInField [] = False
isShipInField (x:[]) = isCoordInField (x)
isShipInField (x:xs) = isCoordInField (x) && isShipInField (xs)

-- | ist die Koordinate innerhalb des Spielfeldes
isCoordInField::(Coord, Status)->Bool
isCoordInField ((x,y),_) = (x `elem` [1..10] && y `elem` [1..10])
                   
-- | Erstellt über einen Zufallsgenerator ein neues Schiff im Feld
getShip::Int->Int->Ship
getShip a i = if(isShipInField neu == True)
                  then neu
                  else getShip (a+1) i
                  where neu = makeFollowingCoords (makeHorizontal (getRandomNum (a+5)))(i-1) ((generateRandomCoord a i):[])

-- | sind die Koordinaten schon im Spielfeld vergeben?
isCoordTaken::[(Coord,Status)]->[(Coord,Status)]->Bool
isCoordTaken [] _ = False
isCoordTaken (x:xs) a = if (x `elem` a) then True
                                        else isCoordTaken xs a

-- | Erstellt eine zufällige Koordinate im Spielfeld
generateRandomCoord::Int->Int->(Coord,Status)
generateRandomCoord a i = ((getRandomNum (a), getRandomNum (a+i)), Fail)

-- | hängt den Rest des Schiffes an die zufällig erstellte Koordinate. Der Boolsche Wert gibt an ob horizontal oder vertikal
makeFollowingCoords::Bool->Int->[(Coord, Status)]->[(Coord, Status)]
makeFollowingCoords a i [] = []
makeFollowingCoords a 0 x = x
makeFollowingCoords a i l = makeFollowingCoords a (i-1) (l ++ (coordPlusOne a (last l)):[])

-- | gibt eine Zufällige Zahl zwischen 1 und 10 zurück. Der Parameter dient als 'salt'
getRandomNum::Int->Int
getRandomNum x = head (randomRs (1,10) g)
                 where g = mkStdGen (getSpezNum x)

-- | Durch diese Funktion kommen mehr verschiedene Zufallszahlen                 
getSpezNum::Int->Int
getSpezNum x = if (x `mod` 2) == 1 
                       then x+getTime
                       else x-getTime

-- | Die übergebene Koordinate wird um eins hochgezählt. Paramter steht für Horizontal oder Vertikal
coordPlusOne::Bool->(Coord,Status)->(Coord,Status)
coordPlusOne False ((x,y),s) = ((x,y+1),s)
coordPlusOne True ((x,y),s) = ((x+1,y),s)

-- | gibt die Systemzeit aus. Wichtig als Salt für den zufallsgenerator
getTime::Int
getTime = round (unsafePerformIO getPOSIXTime) :: Int

-- | ist Paramter >=5 wird False zurück gegeben, sonst True
makeHorizontal::Int->Bool
makeHorizontal a = (a `elem` [1..4])

---------------------------------------------------------
-- Ende Hilfsfunktionen --------------------------------
---------------------------------------------------------