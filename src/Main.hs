module Main where

import System.IO (hSetBuffering, BufferMode(NoBuffering), stdout)


--Einzelner Schuss
type Shoot = (String, Int)
--Schüsse sortiert nach Reihe String = Buchstabe, Erstes Int = Spalte Zweites Int = schuss 0==kein Schuss 1 == Daneben 2 == Treffer
type AllShoots = [(String, [(Int, Int)])]

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    putStr $ "Hallo"

-- druckt den Spielbildschirm
game = printNumbers ++ printAllShoots testShoots
	
testShoots :: AllShoots
testShoots = [("A", [(1,1),(2,1),(3,0),(4,0),(5,2),(6,0),(7,0),(8,0),(9,1),(10,0)]), ("B",[(1,0),(2,0),(3,1),(4,1),(5,2),(6,0),(7,0),(8,0),(9,0),(10,1)]),
              ("C", [(1,0),(2,2),(3,0),(4,0),(5,2),(6,0),(7,0),(8,0),(9,0),(10,0)]), ("D",[(1,0),(2,0),(3,0),(4,0),(5,2),(6,0),(7,0),(8,0),(9,0),(10,0)]),
			  ("E", [(1,1),(2,1),(3,1),(4,0),(5,0),(6,0),(7,0),(8,0),(9,0),(10,0)]), ("F",[(1,0),(2,0),(3,0),(4,0),(5,0),(6,0),(7,0),(8,0),(9,0),(10,0)]),
			  ("G", [(1,0),(2,0),(3,0),(4,0),(5,0),(6,0),(7,0),(8,0),(9,0),(10,0)]), ("H",[(1,0),(2,0),(3,0),(4,0),(5,0),(6,0),(7,0),(8,0),(9,0),(10,0)]),
			  ("I", [(1,0),(2,0),(3,0),(4,0),(5,0),(6,0),(7,0),(8,0),(9,0),(10,0)]), ("J",[(1,0),(2,0),(3,0),(4,0),(5,0),(6,1),(7,0),(8,0),(9,0),(10,0)])]


--Druckt die Schüsse 
printAllShoots :: AllShoots -> String
printAllShoots [] = error "Noch keine Schüsse abgegeben"
printAllShoots [x] = fst x ++ printShoot' (snd x)
printAllShoots (x:xs) = printShoot'' x ++ printAllShoots xs

--Druckt die Spaltenbezeichnung des Spiels
printNumbers = "    1   2   3   4   5   6   7   8   9   10\n\n" 
	  

--Druckt die Reihenbezeichnung (z.B. A)
printShoot'' :: (String, [(Int,Int)]) -> String
printShoot'' x = fst x ++ printShoot' (snd x)
 
-- Druckt einen einzelnen Schuss)
printShoot :: (Int,Int) -> String
printShoot x
    |  snd x ==0 = "    "
    |  snd x ==1 = "   O"
	|  snd x ==2 = "   X"
	
  
--Nimmt alle auf eine Reihe abgefeuerten Schüsse entgegen und druckt sie einzeln
printShoot' :: [(Int,Int)] -> String
printShoot' [x] = printShoot x++"\n\n"
printShoot' (x:xs) = printShoot x ++ printShoot' xs