module Logic where

import Datatypes
import qualified Data.Map as M
myships= [[((fromIntegral 1::Int,fromIntegral 2::Int),Hit),((fromIntegral 2::Int,fromIntegral 3::Int),Fail)]]
enemyField3 = M.fromList[((fromIntegral 1::Int,fromIntegral 1::Int),Fail),((fromIntegral 1::Int,fromIntegral 10::Int),Hit)]

--fügt einen Status im Spielfeld ein. Diese Methode kann sowohl für das gegnerische als auch für das eigene Speilfeld aufgerufen werden
insertStatus::Status->EnemyField->Coord->EnemyField
insertStatus state field (c,i) = M.insert (c,i) state field

--Diese Methode fügt von den Koordinaten (x1,y1) bis (x2,y2) den Status state in das Spielfeld ein
insertStatuus::Coord->Coord->Status->EnemyField->EnemyField
insertStatuus (x1,y1) (x2,y2) state field = insertShipState coordsList state field 
        where coordsList = if(x1==x2)
                                                        then zip  (replicate (y2-y1+1) x1) [y1..y2+1] 
                                                        else zip  (replicate (x2-x1+1) y1) [x1..x2+1] 
                
--Wird von insertStatuus aufgerufen und fügt rekursiv den Status in die Koordinaten der Liste Coords ein                 
insertShipState::Coords->Status->EnemyField->EnemyField
insertShipState [] state field=field
insertShipState (c:cs) state field= insertShipState cs state $ M.insert c state field

--Aktualisiert MyShips, falls Coord eine Schiffskoordinate ist
--Für jedes Schiff aus MyShips wirs shootShip aufgerufen
shootField::Coord->MyShips->MyShips
shootField c = map (shootShip c)
         
--Aktualisiert Ship, falls Coord eine Schiffkoordinate ist
shootShip::Coord->Ship->Ship
shootShip c parts = map (\p ->  if fst p == c 
                                                                        then (c,Hit) 
                                                                        else p) parts

isHit::Coord->MyShips->Bool
isHit c [] = False
isHit c (s:ss) = isHitInShip c s || isHit c ss

isHitInShip::Coord->Ship->Bool
isHitInShip c [] = False
isHitInShip c (s:ss) = flag || isHitInShip c ss
        where flag = if c == fst s && snd s == Fail
                                                then True
                                                else False

coordIsPlayed::Coord->EnemyField->Bool
coordIsPlayed = M.member

initializeField::MyShips->EnemyField
initializeField ships = insertShipsInField ships M.empty

insertShipsInField::MyShips->EnemyField->EnemyField
insertShipsInField [] field = field
insertShipsInField (s:ss) field = M.union (insertShipInField s field) (insertShipsInField ss field)

insertShipInField::Ship->EnemyField->EnemyField
insertShipInField [] field = field
insertShipInField (c:cs) field = M.union (M.insert (fst c) PartShip field) (insertShipInField cs field)

