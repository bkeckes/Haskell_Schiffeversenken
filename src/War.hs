module War where

import Datatypes
import Data.Char (ord)

--Diese Funktion erstellt ein Feld mit Status
makeField::Char -> Integer -> Field -> Field
makeField 'A' i l = makeLine' 'A' i l
makeField a i l = makeField (getNextChar a) i $ makeLine' a i l

--Diese Funktion erstellt eine Coordinatenliste
makeCoordinates::Char -> Integer -> [Coord] -> [Coord]
makeCoordinates 'A' i l = makeLine 'A' i l
makeCoordinates a i l = makeCoordinates (getNextChar a) i $ makeLine a i l

--Diese Funktion erstellt eine Line von Coordinaten
makeLine::Char -> Integer -> [Coord] -> [Coord]
makeLine a 0 c = c
makeLine a b c = makeLine a (b-1) ((makeCoord a b):c)

makeCoord::Char -> Integer -> Coord
makeCoord a b = (a,b)

getNextChar::Char -> Char
getNextChar a = toEnum((ord a)-1)::Char

makeLine'::Char -> Integer -> Field -> Field
makeLine' a 0 c = c
makeLine' a b c = makeLine' a (b-1) ((makeFieldValue (makeCoord a b)):c)

makeFieldValue :: Coord -> (Coord,Status)
makeFieldValue a = (a, None)

