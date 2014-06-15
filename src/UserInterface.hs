module UserInterface where

import Datatypes
import qualified Data.Map as M

enemyField :: EnemyField  
enemyField = M.fromList[(('A',1),Fail),(('A',5),Hit),(('A',10),Destroyed)]

createRow :: Char -> Int -> [Coord]
createRow x 11 = []
createRow x acc = (x, acc) : createRow x (acc + 1)

hilfsfunktion :: [Char] -> Int -> [Coord]
hilfsfunktion x 10 = []
hilfsfunktion x acc = createRow (x!!acc) 1 ++ hilfsfunktion x (acc+1)

createField :: [Coord]
createField = hilfsfunktion ['A'..'J'] 0

-- druckt den Spielbildschirm
-- game = printNumbers ++ map printShoot' createField


--Schaut ob eine Coordinate in der Map ist
valueInMap :: Coord -> Maybe Status
valueInMap x = printShoot $ M.lookup x enemyField
	
--Druckt die Spaltenbezeichnung des Spiels
printNumbers = "    1   2   3   4   5   6   7   8   9   10\n\n" 
	  
	  
printField::Field->String
printField [] = "empty"
printField (x:[]) = "Only one element" ++printField x


--Druckt die Reihenbezeichnung (z.B. A)
-- printShoot'' :: (String, [(Int,Int)]) -> String
-- printShoot'' x = fst x ++ printShoot' (snd x)
 
-- Druckt einen einzelnen Schuss)
-- printShoot :: Maybe Status | Status -> String
-- printShoot x
    -- |  x ==Nothing = "    "
    -- |  x ==Fail = "   O"
	-- |  x ==Hit = "   X"
	-- |  x ==Destroyed = "   #"
  
--Nimmt alle auf eine Reihe abgefeuerten Schüsse entgegen und druckt sie einzeln
-- printShoot' :: [(Int,Int)] -> String
-- printShoot' [x] = printShoot x++"\n\n"
-- printShoot' (x:xs) = printShoot x ++ printShoot' xs


-- Druckt einen einzelnen Schuss
printShoot :: Status -> String
printShoot x
    |  x ==Nothing = "    "
    |  x ==Fail = "   O"
    |  x ==Hit = "   X"
    |  x ==Destroyed = "   #"
	
-- Druckt die Reihen
printShoot' :: Coord -> String
printShoot' x 
    | snd x == 1 = "A    " ++ valueInMap x
    | otherwise = valueInMap x