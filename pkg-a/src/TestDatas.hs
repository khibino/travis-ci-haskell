module TestDatas where

import Data.Maybe
import Data.Time (LocalTime, formatTime, parseTime)
import Data.Time.Locale.Compat (defaultTimeLocale)

int1 :: Int
int1 = 1

ts :: LocalTime
ts = fromMaybe (error "parse error!") $ parseTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" "2017-01-02 12:34:56"

stringHello :: String
stringHello = "Hello" ++ formatTime defaultTimeLocale " %Y-%m-%d %H:%M:%S" ts
