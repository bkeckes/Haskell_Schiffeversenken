module Main where

import System.IO (hSetBuffering, BufferMode(NoBuffering), stdout)
import Datatypes
import UserInterface
import War

import qualified Data.Map as M



-- insertStatus :: Coord -> Status -> EnemyField -> EnemyField
-- insertStatus             
           
enemyField = M.fromList[('A',1),('A',10)]
main :: IO ()
main = do
    putStrLn "Schiffe versenken"
	putStrLn makeField
    -- let myField = generateShips
    -- let enemyField = M.fromList([('A',1),('A',10)])
	-- putStrLn enemyField
	-- Initialisierung
	-- gameLoop myField enemyField sock

	
-- gameLoop gameStatus =
    -- do
		-- Koord einlesen
		-- Schuss übertragen
		-- Antwort
		-- let myGS = gameStatus { myField = ...
                              -- ,  
							  -- }
		-- printFields gameStatus'
		-- gameLoop gameStatus' 