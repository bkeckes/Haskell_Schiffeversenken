module War where

import Datatypes
import Data.Char (ord)

--Diese Funktion erstellt ein Feld
makeField::Char -> Integer -> [Coord] -> [Coord]
makeField 'A' i l = makeLine 'A' i l
makeField a i l = makeField (toEnum((ord a)-1)::Char) i $ makeLine a i l

--Diese Funktion erstellt eine Line von Coordinaten
makeLine::Char -> Integer -> [Coord] -> [Coord]
makeLine a 0 c = c
makeLine a b c = makeLine a (b-1) ((makeCoord a b):c)

makeCoord::Char -> Integer -> Coord
makeCoord a b = (a,b)


charName :: Char -> Integer -> String  
charName 'a' a = "Albert" ++ show a 
charName _ a = "Zahl " ++ show a

zeige = print(ord 'B')
zeige' = print 65



--if b > 0 
					--then makeLine a (b-1) ([a,b] ++ [x])
					--else [x]