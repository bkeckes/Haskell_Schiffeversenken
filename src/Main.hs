module Main where

import System.IO (hSetBuffering, BufferMode(NoBuffering), stdout)


--Einzelner Schuss
type Shoot = (String, Int)
--Schüsse sortiert nach Reihe
type AllShoots = [(String, [Int])]

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    putStr $ "Hallo"

-- druckt den Spielbildschirm
game = printNumbers ++ printAllShoots testShoots
	
testShoots :: AllShoots
testShoots = [("A", [1,2,5,9]), ("B",[3,4,5,10])]


--Druckt die Schüsse 
printAllShoots :: AllShoots -> String
printAllShoots [] = error "Noch keine Schüsse abgegeben"
printAllShoots [x] = fst x ++ printShoot' (snd x)
printAllShoots (x:xs) = printShoot'' x ++ printAllShoots xs

--Druckt die Spaltenbezeichnung des Spiels
printNumbers = "    1   2   3   4   5   6   7   8   9   10\n" 
	  

--Druckt die Reihenbezeichnung (z.B. A)
printShoot'' :: (String, [Int]) -> String
printShoot'' x = fst x ++ printShoot' (snd x)
 
-- Druckt einen einzelnen Schuss)
printShoot :: Int -> String
printShoot x
    | x == 1 = "   O"
	| x == 2 = "   O"
	| x == 3 = "   O"
	| x == 4 = "   O"
	| x == 5 = "   O"
	| x == 6 = "   O"
	| x == 7 = "   O"
	| x == 8 = "   O"
	| x == 9 = "   O"
    | x == 10 = "   O"
	
  
--Nimmt alle auf eine Reihe abgefeuerten Schüsse entgegen und druckt sie einzeln
printShoot' :: [Int] -> String
printShoot' [x] = printShoot x++"\n\n"
printShoot' (x:xs) = printShoot x ++ printShoot' xs