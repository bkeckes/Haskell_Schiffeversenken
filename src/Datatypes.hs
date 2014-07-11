{-|
Module      : Datatypes 
Description : : Definition von Datentypen die für das Spiel benötigt werden
Maintainer  : soulta@hm.edu, keckes@hm.edu

In diesem Modul werden die Datentypen definiert die für das Spiel benötigt werden.
-}
module Datatypes where
import qualified Data.Map as M


-- | Repräsentiert eine Koordinate bestehend aus zwei Int Werten (x-Achse und y-Achse
type Coord = (Int,Int)

-- | Repräsentiert eine Liste von Koordinaten
type Coords = [(Int,Int)]

-- | Repräsentiert ein Schiff. Ein Schiff besteht aus einer Liste von Tupeln. Jeder Tupel enthält eine Koordinate,
-- die die Position, in der sich das Teil des Schiffes befinden, und den aktuellen Status.
type Ship = [(Coord, Status)]
-- 1 Battleship 5
-- 2 cruiser 4
-- 3 destroyer 3
-- 4 submarine 2

-- | Repräsentiert alle eigenen Schiffe als Liste von Ships.
type MyShips = [Ship] 

-- | Repräsentiert den Status den ein Feld haben kann
-- Fail: Ein Feld wurde getroffen, auf dem Schich kein Schiff befindet.
-- Hit: Ein Teil des Schiffes wurde getroffen.
-- Destroyed: Ein Schiff wurde versenkt.
-- PartShip: Ein Teil des Schiffes das noch nicht getroffen wurde.
data Status = Fail | Hit | Destroyed | PartShip deriving (Eq,Show)

-- | Datentyp der angibt wer an der Reihe ust zu spielen
data Turn = Me | Enemy | Again deriving (Eq,Show)

-- | Repräsentiert das eigene und das gegnerische Spielfeld.
-- Wird durch eine Map dargestellt. Key: Koordinate, Value: Status.
type EnemyField  = M.Map Coord Status

-- | Repräsentiert den aktuellen Spielstand und speichert alle Informationen dazu.
data Game = Game {
      myField :: EnemyField,
      enemyField :: EnemyField,
      myShips::MyShips,
      turn::Turn
      } deriving (Eq,Show)
