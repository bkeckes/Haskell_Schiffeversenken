module UserInterface where

import Datatypes
import qualified Data.Map as M

-- enemyField :: EnemyField  
-- enemyField = M.fromList[((1,1),Fail),((1,5),Hit),((1,10),Destroyed)]

createRow :: Int -> Int -> [Coord]
createRow x 11 = []
createRow x acc = (x, acc) : createRow x (acc + 1)

hilfsfunktion :: [Int] -> Int -> [Coord]
hilfsfunktion x 10 = []
hilfsfunktion x acc = createRow (x!!acc) 1 ++ hilfsfunktion x (acc+1)

createField :: [Coord]
createField = hilfsfunktion [1..10] 0

completeField = createField

-- druckt den Spielbildschirm
printMyField x = mapM_ putStr (map (printShoot' x) completeField)

--Schaut ob eine Coordinate in der Map ist
valueInMap :: Coord -> EnemyField -> Maybe Status
valueInMap x y  = M.lookup x y

--Druckt die Spaltenbezeichnung des Spiels
printNumbers = "    1   2   3   4   5   6   7   8   9   10\n\n" 

-- Druckt einen einzelnen Schuss)
printShoot :: Maybe Status -> String
printShoot x
    |  x ==Nothing = "    "
    |  x ==Fail = "   O"
	|  x ==Hit = "   X"
	|  x ==Destroyed = "   #"
  
-- Druckt die Reihen
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
	
	
-- versuch = map (printShoot' enemyField) completeField
