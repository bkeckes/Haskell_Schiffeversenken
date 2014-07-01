module Main where

import System.Random
import System.Time (getClockTime, ClockTime(TOD))
import Data.List (nub) -- nur zum "Debugging"

type Ship = (Integer,Integer)
type Field = [(Integer,Integer)]
emptyField :: Field
emptyField = []

main = do
    -- hole die aktuelle Zeit als Int
    init <- fmap fromInteger $ getClockTime >>= (\(TOD sec _) -> return sec)
    -- initialisiere den RandomGen
    let gen = mkStdGen init
    let randoms = randomRs (1,10) gen -- erzeuge unendliche Liste von Zufallswerten
                                      -- zwischen 1 und 10
    let randomPs = randomPairs randoms -- generiere Paare aus Zufallszahlen
    let field = genRandomField randomPs
    --print $ field == nub field -- Field enthält keine doppelten, nur zum Testen
    print field
	
test::IO ()
test = do
	 -- hole die aktuelle Zeit als Int
    init <- fmap fromInteger $ getClockTime >>= (\(TOD sec _) -> return sec)
    -- initialisiere den RandomGen
    let gen = mkStdGen init
    let ra = take 10 ( randomRs (1,10) gen)
    print 2
    -- print head randoms
--	let randNum = getNum randoms
    -- let randomPs = randomPairs randoms -- generiere Paare aus Zufallszahlen
    -- let field = genRandomField randomPs
    -- print $ field == nub field -- Field enthält keine doppelten, nur zum Testen
    -- print field
	
getNum::[Integer]->Integer
getNum x = head x


randomPairs :: [Integer] -> [(Integer,Integer)]
randomPairs (x:y:rest) = (x,y) : randomPairs rest

insertShipInField :: Ship -> Field -> Field
insertShipInField (x,y) field
    | (x,y) `elem` field =       field
    | otherwise          = (x,y):field

genRandomField :: [Ship] -> Field
genRandomField randoms =
    fst $ genRandomField' emptyField randoms

-- einfügen bis die Bedingung gilt
genRandomField' :: Field -> [Ship] -> (Field, [Ship])
genRandomField' field (ship:ships)
    | enoughShips field = (field, [])
    | otherwise = genRandomField' (insertShipInField ship field) ships

-- hier muss Ihre Bedingung an das Feld stehen
enoughShips :: Field -> Bool
enoughShips = (>=100) . length

