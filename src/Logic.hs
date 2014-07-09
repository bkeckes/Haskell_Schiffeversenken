{-|
Module      : Logic 
Description : : Stellt Funktionen für den Ablauf des Spieles zur Verfügung
Maintainer  : soulta@hm.edu

Dieses Modul stellt Funktionen für den Spielablauf zur Verfügung.
-}

module Logic where

import Datatypes
import qualified Data.Map as M


-- | Fügt einen Status im Spielfeld in der übergebenen Koordinate ein. 
-- Diese Funktion kann sowohl für das gegnerische als auch für das eigene Spielfeld aufgerufen werden.
insertStatus::Status->EnemyField->Coord->EnemyField
insertStatus state field (c,i) = M.insert (c,i) state field

-- | Diese Funktion fügt von den Koordinaten (x1,y1) bis (x2,y2) den übergebenen Status in das Spielfeld ein.
--  Falls x1==x2 liegt das Schiff vertikal, andernfalls liegt es horizontal zum Spielfeld.
insertStatuus::(Coord,Coord)->Status->EnemyField->EnemyField
insertStatuus ((x1,y1),(x2,y2)) state field = insertShipState coordsList state field 
        where coordsList = if(x1==x2) 
                              then zip  (replicate (y2-y1+1) x1) [y1..y2+1] 
                              else zip  (replicate (x2-x1+1) y1) [x1..x2+1] 
                
-- | Diese Funktion wird von insertStatuus aufgerufen und fügt rekursiv in das Spielfeld den Status in die Koordinaten der Liste Coords ein                 
insertShipState::Coords->Status->EnemyField->EnemyField
insertShipState [] state field=field
insertShipState (c:cs) state field= insertShipState cs state $ M.insert c state field

-- | Aktualisiert MyShips, falls Coord eine Schiffskoordinate ist.
-- Für jedes Schiff aus MyShips wird die Funktion shootShip aufgerufen.
shootField::Coord->MyShips->MyShips
shootField c = map (shootShip c)
         
-- | Aktualisiert Ship mit dem Status Hit, falls Coord eine Schiffkoordinate ist
shootShip::Coord->Ship->Ship
shootShip c parts = map (\p ->  if fst p == c 
									then (c,Hit) 
									else p) parts


-- | Falls die übergebene Koordinate eine Schiffskoordinate ist, die noch nicht gespielt wurde (Status: PartShip)
-- gibt diese Funktion True zurück. Dazu wird für jedes Schiff aus der Übergebenen Liste von Schiffen (MyShips)
-- die Funktion isHitInShip aufgerufen.
isHit::Coord->MyShips->Bool
isHit c [] = False
isHit c (s:ss) = isHitInShip c s || isHit c ss

-- | Diese Funktion wird von isHit aufgerufen. Falls die übergebene Koordinate in Ship enthalten ist, gibt sie True zurück, ansonten False.
isHitInShip::Coord->Ship->Bool
isHitInShip c [] = False
isHitInShip c (s:ss) = flag || isHitInShip c ss
        where flag = if c == fst s && snd s == PartShip
                                                then True
                                                else False

-- | Diese Funktion wird aufgerufen damit sichergestellt wird damit ein Spieler nicht mehrmals die selbe Koordinate spielt. 
-- Falls die Koordinate in EnenmyField enthalten ist also gespielt wurde, gibt diese Funktion True zurück, ansonsten False.
coordIsPlayed::Coord->EnemyField->Bool
coordIsPlayed = M.member


-- | Diese Funktion wird am Anfang des Spieles aufgerufen, nachdem die eigenen Schiffe generiert wurden.
-- Sie fügt alle eigenen Schiffe mit dem Status PartShip ins eigene Spielfeld ein und gibt dieses zurück. 
initializeField::MyShips->EnemyField
initializeField ships = insertShipsInField ships M.empty

-- | Diese Funktion wir von initializeField aufgerufen und ruft für jedes Schip in der Liste MyShips die 
-- insertShipInField Funtkion auf.
insertShipsInField::MyShips->EnemyField->EnemyField
insertShipsInField [] field = field
insertShipsInField (s:ss) field = M.union (insertShipInField s field) (insertShipsInField ss field)

-- | Diese Fuktion wird von insertShipsInField aufgerufen und fügt in das Spielfeld alle Koordinaten des Shiffes mit dem Status PartShip ein.
insertShipInField::Ship->EnemyField->EnemyField
insertShipInField [] field = field
insertShipInField (c:cs) field = M.union (M.insert (fst c) PartShip field) (insertShipInField cs field)

