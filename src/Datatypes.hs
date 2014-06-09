module Datatypes where
import qualified Data.Map as M


--Coordinate bestehend aus Buchstaben und Zahl
type Coord = (Char,Int)

type Ship = [(Coord, Status)]

type MyShips = [Ship]


data Status = Fail | Hit | Destroyed

type EnemyField  = M.Map Coord Status

-- data Game = Game {
      -- myField :: ...
	  -- enemyField :: ...
	  -- sock :: ...
	  -- myShoot :: Bool
    -- }