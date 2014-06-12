module Logic where

import Datatypes

import qualified Data.Map as M
myships= [(('A',2),Hit),(('B',3),Fail)]

insertStatus::Coord->Status->EnemyField->EnemyField
insertStatus (c,i) state field = M.insert (c,i) state field

shootField::Coord->MyShips->MyShips
shootField c = map (shootShip c)
	 

	
shootShip::Coord->Ship->Ship
shootShip c parts = map (\p ->  if fst p == c 
									then (c,Hit) 
									else p) parts
