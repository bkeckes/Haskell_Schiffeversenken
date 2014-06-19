module Datatypes where
import qualified Data.Map as M


--Coordinate bestehend aus Buchstaben und Zahl
type Coord = (Int,Int)

type Coords = [(Int,Int)]

type Ship = [(Coord, Status)]

type MyShips = [Ship] 


data Status = Fail | Hit | Destroyed deriving (Eq,Show)

type EnemyField  = M.Map Coord Status

-- data Game = Game {
      -- myField :: ...
	  -- enemyField :: ...
	  -- sock :: ...
	  -- myShoot :: Bool
    -- }
