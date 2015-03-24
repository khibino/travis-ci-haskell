
import TestDatas (int1, stringHello)

import Control.Applicative ((<$>))
import Control.Monad (unless)
import Data.Maybe (catMaybes)
import System.IO (stderr, hPutStrLn)
import Test.QuickCheck
  (Testable, Property, Result (..), quickCheckResult, label)


type Test = (String, Property)

testProperty :: Testable prop => String -> prop -> Test
testProperty m = (,) m . label m

runMayError :: Testable prop => (a, prop) -> IO (Maybe (a, Result))
runMayError (m, prop) = fmap ((,) m) . err <$> quickCheckResult prop  where
  err :: Result -> Maybe Result
  err (Success {})  =  Nothing
  err x             =  Just x

run :: [Test] -> IO ()
run xs = do
  es <- catMaybes <$> mapM runMayError xs
  mapM_ (\(m, r) -> hPutStrLn stderr $ m ++ ":\n" ++ show r) es
  unless (null es) $ fail "Found some failures."

main :: IO ()
main = run tests


prop_int1 :: Bool
prop_int1 = int1 == 1

prop_stringHello :: Bool
prop_stringHello = stringHello == "Hello"

prop_show_read :: Int -> Bool
prop_show_read i = read (show i) == (i :: Int)

tests :: [Test]
tests =  [ testProperty "int1"         prop_int1
         , testProperty "stringHello"  prop_stringHello
         -- -- , testProperty "int1Bad"         $ int1 == 2
         -- -- , testProperty "stringHelloBad"  $ stringHello == "Hellox"
         , testProperty "show read"    prop_show_read
         ]
