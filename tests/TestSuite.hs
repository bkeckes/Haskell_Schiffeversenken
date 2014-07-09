module Main where

import Test.Framework
import Test.Framework.Providers.HUnit

import Test.HUnit

import Logic
import Datatypes
import qualified Data.Map as M



main :: IO ()
main = defaultMain tests

tests :: [Test.Framework.Test]
tests =
  [  testGroup "HUnit Tests"
    [ testCase "A rented movie is returnable." test_insertStatus
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
{-
testReturn :: Assertion
testReturn =
  let
    ident = 3
    movie = (ident, "The Breakfast Club", 12)
    moviestore = ( [ (1, "Matrix", 16)
                   , (2, "Alpen - unsere Berge von oben", 0)
                   ]
                 , [ movie
                   ]
                 )
    (available', rentable') = Moviestore.return ident moviestore
  in assertBool "Rented movie should be available and not rented after returning it"      
    $ movie `elem` available' && movie `notElem` rentable'
-}
