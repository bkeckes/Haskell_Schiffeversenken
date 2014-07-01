module Datatypes where
import qualified Data.Map as M


--Coordinate bestehend aus Buchstaben und Zahl

-- type Coord = (Char,Int)
        

type Coord = (Int,Int)

type Coords = [(Int,Int)]

type Field = [(Coord,Status)]

type Ship = [(Coord, Status)]
-- 1 Battleship 5
-- 2 cruiser 4
-- 3 destroyer 3
-- 4 submarine 2

type MyShips = [Ship] 

data Status = Fail | Hit | Destroyed | PartShip deriving (Eq,Show)


type EnemyField  = M.Map Coord Status

-- data Game = Game {
      -- myField :: ...
          -- enemyField :: ...
          -- sock :: ...
          -- myShoot :: Bool
    -- }
