module War where

import Datatypes
import Data.Char (ord)

--Diese Funktion erstellt ein Feld
makeField::Char -> Integer -> [Coord] -> [Coord]
makeField 'A' i l = makeLine 'A' i l
makeField a i l = makeField (getNextChar a) i $ makeLine a i l

--Diese Funktion erstellt eine Line von Coordinaten
makeLine::Char -> Integer -> [Coord] -> [Coord]
makeLine a 0 c = c
makeLine a b c = makeLine a (b-1) ((makeCoord a b):c)

makeCoord::Char -> Integer -> Coord
makeCoord a b = (a,b)

getNextChar::Char -> Char
getNextChar a = toEnum((ord a)-1)::Char



--if b > 0 
					--then makeLine a (b-1) ([a,b] ++ [x])
					--else [x]