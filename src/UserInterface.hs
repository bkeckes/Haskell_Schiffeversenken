module UserInterface where

import Datatypes
import qualified Data.Map as M

-- | 'createRow' erzeugt eine Zeile des Spielfelds
createRow :: Int -> Int -> [Coord]
createRow x 11 = []
createRow x acc = (x, acc) : createRow x (acc + 1)

-- | 'addRowToField' fügt dem Spielfeld eine Zeile hinzu
addRowToField :: [Int] -> Int -> [Coord]
addRowToField x 10 = []
addRowToField x acc = createRow (x!!acc) 1 ++ addRowToField x (acc+1)

-- | 'createField' lässt das Spielfeld erzeugen
createField :: [Coord]
createField = addRowToField [1..10] 0
-- | 'printHeadLineMyShoots' druckt die Titelzeile des Spielfelds sowie die Überschrift des Felds
printHeadLineMyShoots :: IO ()
printHeadLineMyShoots = do
    putStrLn ("\n          Meine abgefeuerten Schüsse\n")
    printNumbers

-- | 'printHeadLineMyShips' druckt die Titelzeile des Spielfelds sowie die Überschrift des Felds
printHeadLineMyShips :: IO ()
printHeadLineMyShips = do
    putStrLn ("\n               Meine Schiffe\n")
    printNumbers
	
-- | 'printField' druckt den Spielbildschirm 
printField x = mapM_ putStr (map (printShoot' x) createField)

-- | 'valueInMap' schaut ob eine Coordinate in der Map ist
valueInMap :: Coord -> EnemyField -> Maybe Status
valueInMap x y  = M.lookup x y

-- | 'printNumbers' druckt die Spaltenbezeichnung des Spiels
printNumbers = putStr "    1   2   3   4   5   6   7   8   9   10\n\n" 

-- | 'printShoot' druckt dass Ergebnis eines einzelnen Schuss
printShoot :: Maybe Status -> String
printShoot x
    |  x ==Nothing = "    "
    |  x ==Just Fail = "   O"
	|  x ==Just Hit = "   X"
	|  x ==Just Destroyed = "   #"
    |  x ==Just PartShip ="   +"

-- | 'printShoot'' druckt die Zeilen Bezeichnung und den einzelnen Schuss
printShoot' :: EnemyField -> Coord -> String
printShoot' x y
    | fst y == 1 && snd y == 1 = "A" ++ printShoot (valueInMap y x)
	| fst y == 2 && snd y == 1 = "B" ++ printShoot (valueInMap y x)
    | fst y == 3 && snd y == 1 = "C" ++ printShoot (valueInMap y x)
    | fst y == 4 && snd y == 1 = "D" ++ printShoot (valueInMap y x)
    | fst y == 5 && snd y == 1 = "E" ++ printShoot (valueInMap y x)
    | fst y == 6 && snd y == 1 = "F" ++ printShoot (valueInMap y x)
    | fst y == 7 && snd y == 1 = "G" ++ printShoot (valueInMap y x)
    | fst y == 8 && snd y == 1 = "H" ++ printShoot (valueInMap y x)
    | fst y == 9 && snd y == 1 = "I" ++ printShoot (valueInMap y x)
    | fst y == 10 && snd y == 1 = "J" ++ printShoot (valueInMap y x)
    | snd y == 10 = printShoot ( valueInMap y x) ++ "\n\n"
    | otherwise = printShoot (valueInMap y x)

