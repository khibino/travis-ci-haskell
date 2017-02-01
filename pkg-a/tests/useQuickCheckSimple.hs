
import TestDatas (int1, stringHello)

import Test.QuickCheck.Simple (Test, boolTest, qcTest, defaultMain)


main :: IO ()
main = defaultMain tests


prop_int1 :: Bool
prop_int1 = int1 == 1

prop_stringHello :: Bool
prop_stringHello = stringHello == "Hello 2017-01-02 12:34:56"

prop_show_read :: Int -> Bool
prop_show_read i = read (show i) == (i :: Int)

tests :: [Test]
tests =  [ boolTest "int1"         prop_int1
         , boolTest "stringHello"  prop_stringHello
         , qcTest    "show read"   prop_show_read
         ]
