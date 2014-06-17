module Datatypes where
import qualified Data.Map as M


--Coordinate bestehend aus Buchstaben und Zahl
-- type Coord = (Char,Int)
	
type Coord = (Char,Int)

type Field = [(Coord,Status)]

type Ship = [(Coord, Status)]

type MyShips = [Ship]

data Status = Fail | Hit | Destroyed | None
    deriving (Show)
	

type EnemyField  = M.Map Coord Status

-- data Game = Game {
      -- myField :: ...
	  -- enemyField :: ...
	  -- sock :: ...
	  -- myShoot :: Bool
    -- }