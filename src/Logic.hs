module Logic where

import Datatypes

import qualified Data.Map as M
myships= [[((1,2),Hit),((2,3),Fail)]]
enemyField3 = M.fromList[((fromIntegral 1::Int,fromIntegral 1::Int),Fail),((fromIntegral 1::Int,fromIntegral 10::Int),Hit)]


insertStatus::Status->EnemyField->Coord->EnemyField
insertStatus state field (c,i) = M.insert (c,i) state field



insertStatuus::Coord->Coord->Status->EnemyField->EnemyField
insertStatuus (x1,y1) (x2,y2) state field = insertShipState coordsList state field 
	where coordsList = if(x1==x2)
							then zip  (replicate (y2-y1+1) x1) [y1..y2+1] 
							else zip  (replicate (x2-x1+1) y1) [x1..x2+1] 
		
--map (insertStatus state field) coordsList 
		
insertShipState::Coords->Status->EnemyField->EnemyField
insertShipState [] state field=field
insertShipState (c:cs) state field= insertShipState cs state $ M.insert c state field

shootField::Coord->MyShips->MyShips
shootField c = map (shootShip c)
	 
shootShip::Coord->Ship->Ship
shootShip c parts = map (\p ->  if fst p == c 
									then (c,Hit) 
									else p) parts

