module Main where

import Test.Framework
import Test.Framework.Providers.HUnit
import Test.Framework.Providers.QuickCheck2

import Test.QuickCheck
import Test.HUnit

import Moviestore

main :: IO ()
main = defaultMain tests

tests :: [Test.Framework.Test]
tests =
  [ testGroup "QuickCheck Tests"
    [ testProperty "The first movie in a list is extractable." prop_extractFirst
    ]
  , testGroup "HUnit Tests"
    [ testCase "A rented movie is returnable." testReturn
    ]
  ]

-- QuickCheck

prop_extractFirst :: [Movie] -> Property
prop_extractFirst movies =
    not (null movies)
        ==> (extract i movies == (Just m, ms))
  where
    (m@(i,_,_):ms) = movies

-- HUnit

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
  in assertBool "Rented movie should be available and not rented after returning it"        $ movie `elem` available' && movie `notElem` rentable'
