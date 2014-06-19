module Tests where

import Datatypes
import War

getTestShip1::Ship
getTestShip1 = [((1,1),Fail), ((1,2),Hit), ((1,3), Hit)]

getTestShip2::Ship
getTestShip2 = [((2,1),Hit), ((2,2),Hit), ((2,3), Fail)]

getTestShip3::Ship
getTestShip3 = [((2,6),Hit), ((2,7),Hit), ((2,8), Fail)]

getTestShip4::Ship
getTestShip4 = [((3,6),Hit), ((4,6),Hit), ((5,6), Hit)]

getS::MyShips
getS = [getTestShip1,getTestShip2,getTestShip3, getTestShip4]
