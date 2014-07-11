module War where

import Datatypes
import Data.Char (ord)
import System.Random
import Logic

import System.IO.Unsafe
import Data.Time.Clock.POSIX
import System.Random
import System.Time (getClockTime, ClockTime(TOD))




--ist ein Schiff der Liste komplett gesunken?
isAShipDestroyed::MyShips->Bool
isAShipDestroyed [] = False
isAShipDestroyed (x:[]) = (hasShipState Hit x)
isAShipDestroyed (x:xs) = (hasShipState Hit x) || (isAShipDestroyed xs)

--gibt Anfang und Ende eines zerstörtem Schiffs zurück
--und setzt Status auf destroyed
getCoordsFromDestroyed::MyShips->(Coord,Coord)
getCoordsFromDestroyed ships = getStartAndEnd $ getShipWithState Hit ships

setShipToDestroyed::MyShips->MyShips
setShipToDestroyed ships = changeShip ships $ changeStatusToDestroyed $ getShipWithState Hit ships

--setzt durch Zufall alle Shiffe in das Feld
generateMyShips::MyShips
generateMyShips = generateNewShip 0 2 
                  $ generateNewShip 0 2 
				  $ generateNewShip 0 3 
				  $ generateNewShip 0 3 
				  $ generateNewShip 0 3 
				  $ generateNewShip 0 4 
				  $ generateNewShip 0 4 
				  $ generateNewShip 0 5 [] -- $ generateNewShip 5 []
				  
				  
test::Int
test = let a = 2
           b = a+4
		in a+b


-- generateMyShips' :: IO MyShips
-- generateMyShips' = do
-- gen <- getStdGen (randomR (1,10))
-- (val, nextGen) <- next gen	
-- let newShip = genNewShip val 2
--einfügen

-- genNewShip::Int -> Int -> Ship
-- genNewShip randomNo lOfShip = undefined

-- eins::IO Integer
-- eins =  fromInteger $ getClockTime >>= (\(TOD sec _) -> return sec)
	

---------------------------------------------------------
--  Hilfsfunktionen -------------------------------------
---------------------------------------------------------

-- Tauscht das Schiff in der Liste aus
changeShip::MyShips->Ship->MyShips
changeShip [] _ = []
changeShip (x:[]) s = if(isSameShip x s)
                       then s:[]
					   else x:[]
changeShip (x:xs) s = if(isSameShip x s)
                        then s:xs
                        else x : ( changeShip xs s )

--Vergleicht die Anfangskoordinaten zweier Schiffe						
isSameShip::Ship->Ship->Bool
isSameShip [] _ = True
isSameShip _ [] = True
isSameShip (x:xs) (y:ys) = isSameCoord x y && (isSameShip xs ys)

--Vergleicht Koordinaten
isSameCoord::(Coord,Status)->(Coord,Status)->Bool
isSameCoord (a,_) (b,_) = a==b


--Ist das Schiff komplett getroffen? Also auf jeder Kooridinate Status = Hit?
hasShipState::Status->Ship->Bool
hasShipState state [] = True
hasShipState state (x:[]) = isCoordState state x
hasShipState state (x:xs) = (isCoordState state x) && (hasShipState state xs)

--ist der Status dieser Koordinate Hit?
isCoordState::Status->(Coord, Status) -> Bool
isCoordState state (_,s) = if (s==state) then True
                               else False

--gib zerstörtes Shiff zurück                                                           
getShipWithState::Status->MyShips->Ship
getShipWithState state [] = []
getShipWithState state (x:[]) = if(hasShipState state x) == True
                            then x
                            else []
getShipWithState state (x:xs) = if(hasShipState state x) == True
                           then x
                           else getShipWithState state xs
						   

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


----Es wird ein neues Schiff in die Liste eingefügt. Dann wird die Liste zurück gegeben
generateNewShip::Int->Int->MyShips->MyShips
generateNewShip salt laenge feld = if (neuesFeld == feld)
                            then generateNewShip (salt+1) laenge feld
                            else neuesFeld
                            where neuesFeld = (insertShip (getShip salt laenge) feld)
                                          
										  
								
-- Ein Schiff wird in die Liste eingefügt                                          
insertShip::Ship->MyShips->MyShips
insertShip n s = if ((isCoordTaken n (makeOneList s [((1,1),Fail)]))) == False
                         then n : s
                         else s

--Es wird eine lange Liste aus allen Schiffen erstellt                                                 
makeOneList::MyShips->[(Coord,Status)]->[(Coord,Status)]
makeOneList [] l = l
makeOneList (x:[]) l = l ++ x
makeOneList (x:xs) l = (makeOneList xs l) ++ x 

--Sind alle Teile eines Schiffs innerhalb der Koordinaten
isShipInField::Ship->Bool
isShipInField (x:[]) = isCoordInField (x)
isShipInField (x:xs) = isCoordInField (x) && isShipInField (xs)

--ist die Koordinate innerhalb des Spielfeldes
isCoordInField::(Coord, Status)->Bool
isCoordInField ((x,y),_) = (x `elem` [1..10] && y `elem` [1..10])
                   
--Erstellt über einen Zufallsgenerator ein neues Schiff im Feld
getShip::Int->Int->Ship
getShip a i = if(isShipInField neu == True)
                  then neu
                  else getShip (a+1) i
                  where neu = makeFollowingCoords (makeHorizontal (getRandomNum (a+5)))(i-1) ((generateRandomCoord a i):[])                                          

--sind die Koordinaten schon im Spielfeld vergeben?                          
isCoordTaken::[(Coord,Status)]->[(Coord,Status)]->Bool
isCoordTaken [] a = False
isCoordTaken (x:xs) a = if (x `elem` a) then True
                                        else isCoordTaken xs a

--Erstellt eine zufällige Koordinate im Spielfeld                                                                                
generateRandomCoord::Int->Int->(Coord,Status)
generateRandomCoord a i = ((getRandomNum (a), getRandomNum (a+2)), Fail)

--hängt an die zufällig erstellte Koordinate den Rest des Schiffes
--der Boolsche Wert gibt an ob horizontal oder vertikal
makeFollowingCoords::Bool->Int->[(Coord, Status)]->[(Coord, Status)]
makeFollowingCoords a i [] = []
makeFollowingCoords a 0 x = x
makeFollowingCoords a i l = makeFollowingCoords a (i-1) (l ++ (coordPlusOne a (last l)):[])
-- makeFollowingCoords a i (x:[]) = makeFollowingCoords a (i-1) (coordPlusOne x:(x:[]))
-- makeFollowingCoords a i (x:xs) = makeFollowingCoords a (i-1) (coordPlusOne x:(x:xs))

--gibt eine Zufällige Zahl zwischen 1 und 10 zurück. Der Parameter dient als 'salt'
getRandomNum::Int->Int
getRandomNum x = head (randomRs (1,10) g)
                 where g = mkStdGen (x-getTime)

--Die übergebene Koordinate wird um eins hochgezählt. Paramter steht für Horizontal oder Vertikal
coordPlusOne::Bool->(Coord,Status)->(Coord,Status)
coordPlusOne False ((x,y),s) = ((x,y+1),s)
coordPlusOne True ((x,y),s) = ((x+1,y),s)

-- gibt die Systemzeit aus. Wichtig als Salt für den zufallsgenerator
getTime::Int
getTime =  round (unsafePerformIO getPOSIXTime) :: Int

-- getInit::IO ()
-- getInit = do
            -- init <- fmap fromInteger $ getClockTime >>= (\(TOD sec _) -> return sec)
            -- let gen = mkStdGen init
            -- let randoms = randomRs (1,10) gen -- erzeuge unendliche Liste von Zufallswerten
                                    		  -- zwischen 1 und 10
            -- let randomPs = randomPairs randoms -- generiere Paare aus Zufallszahlen
            -- let field = genRandomField randomPs
            -- print $ field == nub field -- Field enthält keine doppelten, nur zum Testen
            -- print field
           -- print 2

--ist Paramter >=5 wird False zurück gegeben, sonst True
makeHorizontal::Int->Bool
makeHorizontal a = (a `elem` [1..4])                        



---------------------------------------------------------
--  Ende Hilfsfunktionen --------------------------------
---------------------------------------------------------
                                                           





--gibt eine zufällige Coordinate aus der Liste zurück
--getRandomCoord::[Coord]->Coord
--getRandomCoord:        g <- getStdGen
--                                print $ take 10 (randomRs ('a', 'z') g)

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
