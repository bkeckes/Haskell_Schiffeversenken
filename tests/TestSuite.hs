module Main where

import Test.Framework
import Test.Framework.Providers.HUnit

import Test.HUnit

import Logic
import War
import Datatypes
import qualified Data.Map as M



main :: IO ()
main = defaultMain tests

tests :: [Test.Framework.Test]
tests =
  [  testGroup "HUnit Tests"
    [ testCase "Status einfuegen" test_insertStatus,
	  testCase "Statuus" test_insertStatuus,
	  testCase "isHit" test_isHit,
	  testCase "shootField" test_shootField,
	  testCase "coordIsPlayed" test_coordIsPlayed,
       --Bennis Tests
       testCase "Erkennen der zerstoerten Schiffe" test_isOneShipDestroyed,
       testCase "Richtige Koordinaten vom zerstoerten Schiff?" test_getCoordsFromDestroyed,
       testCase "Zerstoertes Schiff soll als Destroyed markiert werden" test_setShipToDestroyed,
       testCase "Schiffe ueberlagern sich nicht" test_generateMyShips
    ]
  ]


test_insertStatus :: Assertion
test_insertStatus =
    let
           tstate=Hit
           tstate2=Fail
           tenemyField=M.empty
           tenemyField2=M.fromList[((fromIntegral 1::Int,fromIntegral 1::Int),PartShip)]
           tcoord=(1,1)
           tcoord1=(2,2)
    in assertBool "State in enemyField?"
           $((insertStatus tstate tenemyField tcoord1) M.! tcoord1 == tstate) &&
           ((insertStatus tstate2 tenemyField2 tcoord) M.! tcoord == tstate2)
           
-- | Insert Ship State wird mitgetstet
test_insertStatuus::Assertion
test_insertStatuus=
     let 
               tstate=Hit
               tcoords=((1,2),(1,5))
               tenemyField=M.fromList[((fromIntegral 1::Int,fromIntegral 1::Int),PartShip)]
     in assertBool "States inserted?"
               $ ((insertStatuus tcoords tstate tenemyField) M.! (1,2) ==tstate) &&
                    ((insertStatuus tcoords tstate tenemyField) M.! (1,3) ==tstate) &&
                    ((insertStatuus tcoords tstate tenemyField) M.! (1,4) ==tstate) &&
                    ((insertStatuus tcoords tstate tenemyField) M.! (1,5) ==tstate)
-- | isHitInShip wird mitgetestet     
test_isHit::Assertion
test_isHit = 
     let tcoord = (1,1)
         tcoord1 = (3,3)
         tships=[[((fromIntegral 3::Int,fromIntegral 3::Int),PartShip),((fromIntegral 4::Int,fromIntegral 3::Int),PartShip),((fromIntegral 5::Int,fromIntegral 3::Int),PartShip)]]
     in assertBool "Ist die Koordinate in ships enthalten?"
               $ ((isHit tcoord tships)==False)&&
                 (isHit tcoord1 tships)

-- | Testet shootShips mit 
test_shootField::Assertion --Coord->MyShips->MyShips
test_shootField =
     let 
               tcoord=(4,3)
               tcoord2=(4,4)
               tships=[[((fromIntegral 3::Int,fromIntegral 3::Int),PartShip),((fromIntegral 4::Int,fromIntegral 3::Int),Hit),((fromIntegral 5::Int,fromIntegral 3::Int),PartShip)]]
               tnewships= shootField tcoord tships
     in assertBool "Ship shooted?"
          $ (isHit tcoord tnewships)&&
            ((isHit tcoord2 tnewships)==False)
          
test_coordIsPlayed::Assertion
test_coordIsPlayed=
     let 
               tcoord=(1,1)
               tcoord2 = (1,3)
               tenemyField=M.fromList[((fromIntegral 1::Int,fromIntegral 1::Int),Hit)]
     in assertBool "Wurde die Koordinate schon gespielt?"
          $(coordIsPlayed tcoord tenemyField)&&
           ((coordIsPlayed tcoord2 tenemyField)==False)
          
--------------------------------------------------
-- Bennis Tests
---------------------------------------------------
test_isOneShipDestroyed :: Assertion
test_isOneShipDestroyed =
        assertBool "Ist das Schiff zerstoert?"
        $((hasShipState Hit getTS2 == True) &&
         (hasShipState Hit getTS6 == True) &&
         (hasShipState Hit getTS5 == False) &&
         (hasShipState Hit getTS3 == False)
         )
          

test_getCoordsFromDestroyed :: Assertion
test_getCoordsFromDestroyed =
        assertBool "Sind das die Koordinaten des zerstoerten Schiffes?"
        $((getCoordsFromDestroyed getS == ((2,1),(2,3)) ) && 
          ( getCoordsFromDestroyed [getTS1, getTS5, getTS6] == ((2,4),(2,8)) ) &&
            ( getCoordsFromDestroyed [getTS1, getTS5, getTS4] == ((0,0),(0,0)) )
           )

           
test_setShipToDestroyed :: Assertion
test_setShipToDestroyed = assertBool "Hat sich Status geaendert?"
        $((setShipToDestroyed [getTS1, getTS5, getTS2] == [getTS1, getTS5, [((2,1),Destroyed), ((2,2),Destroyed), ((2,3), Destroyed)]] ) &&
          ( setShipToDestroyed [getTS1, getTS5, getTS3] == [getTS1, getTS5, getTS3] ) &&
            ( setShipToDestroyed [getTS1, getTS5, getTS4] == [getTS1, getTS5, getTS4] )
           )

test_generateMyShips :: Assertion
test_generateMyShips = assertBool "Kommt eine Koordinate oefter vor?"           
          $(( kommtDoppelt (makeOneList [getTS1, getTS5, getTS2] []) [] == False ) &&
          ( kommtDoppelt (makeOneList [getTS1, getTS5, getTS4] []) [] == True ) &&
            ( kommtDoppelt (makeOneList generateMyShips []) [] == False ) 
          )
           
-- Hilfsfunktion für das Testen ob eine Koordinate öfter verwendet wird. Also ob sich Schiffe überlagern           
kommtDoppelt :: [(Coord,Status)] -> [(Coord,Status)] -> Bool
kommtDoppelt [] _ = False
kommtDoppelt (x:xs) schonGehabt = if(x `elem` schonGehabt)
                                   then True
                                   else (kommtDoppelt xs (x:schonGehabt))
           
getTS1::Ship
getTS1 = [((9,1),Fail), ((9,2),Fail), ((9,3), Fail)]

getTS2::Ship
getTS2 = [((2,1),Hit), ((2,2),Hit), ((2,3), Hit)]

getTS3::Ship
getTS3 = [((2,4), Fail), ((2,5), Fail), ((2,6),Fail), ((2,7),Fail), ((2,8), Fail)]

getTS4::Ship
getTS4 = [((3,6),Fail), ((4,6),Fail), ((5,6), Hit)]

getTS5::Ship
getTS5 = [((4,5),Hit), ((4,6),Fail), ((4,7), Hit)]

getTS6::Ship
getTS6 = [((2,4), Hit), ((2,5), Hit), ((2,6),Hit), ((2,7),Hit), ((2,8), Hit)]

getS::MyShips
getS = [getTS1,getTS2,getTS3, getTS4]
