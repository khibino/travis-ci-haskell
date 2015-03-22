
import TestDatas (int1, stringHello)

import Test.Framework
import Test.Framework.Providers.QuickCheck2

prop_int1 :: Bool
prop_int1 = int1 == 1

prop_show_read :: Int -> Bool
prop_show_read i = read (show i) == (i :: Int)

tests :: [Test]
tests =  [ testProperty "int1"       prop_int1
         , testProperty "show read"  prop_show_read
         ]

main :: IO ()
main = defaultMain tests
