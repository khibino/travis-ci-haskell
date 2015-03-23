
import TestDatas (int1, stringHello)

import Control.Applicative ((<$>))
import Data.Monoid (Monoid (..), Last (..), mconcat)
import Test.QuickCheck
  (Testable, Property, Result (..), quickCheckResult, label)


lastError :: Result -> Last Result
lastError = d  where
  d (Success {})  =  Last   Nothing
  d x             =  Last $ Just x

run :: Testable prop => [prop] -> IO ()
run xs = do
  e <- getLast . mconcat <$> mapM (fmap lastError . quickCheckResult) xs
  maybe (return ()) (fail . show) e

prop_int1 :: Bool
prop_int1 = int1 == 1

prop_stringHello :: Bool
prop_stringHello = stringHello == "Hello"

prop_show_read :: Int -> Bool
prop_show_read i = read (show i) == (i :: Int)

tests :: [Property]
tests =  [ label "int1"         prop_int1
         , label "stringHello"  prop_stringHello
         , label "show read"    prop_show_read
         ]

main :: IO ()
main =  run tests
