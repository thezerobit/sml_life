module Main where
import qualified Data.Vector.Unboxed as V

main = putStrLn result

type GridArray = V.Vector Int
type Grid = GridArray

gridArrayFromList :: [Int] -> GridArray
gridArrayFromList v = V.fromList v

w = 5
h = 5

startGrid =
  gridArrayFromList [0,0,0,0,0,
                     0,1,1,1,0,
                     0,1,0,0,0,
                     0,0,1,0,0,
                     0,0,0,0,0]

cellToChar 0 = '0'
cellToChar 1 = '1'

gridListToStr :: ([Int], Int, Int) -> [Char]
gridListToStr ([], w, h) = []
gridListToStr (v, w, h) = [ cellToChar x | x <- (take w v) ] ++ "\n" ++
  gridListToStr (drop w v, w, h)

gridToStr :: Grid -> [Char]
gridToStr ga = gridListToStr (V.toList ga, w, h)


iter v =
  let surrounding = V.fromList [(-1,-1), (0,-1), (1,-1),
                     (-1, 0), (1, 0),
                     (-1, 1), (0, 1), (1, 1)]

      getOffset :: Int -> (Int, Int) -> Int
      getOffset current (x, y) =
        let destX = (current + x) `mod` w
            destY = ((current `div` w) + y) `mod` h
        in destY * w + destX
      getNext :: Int -> Int -> Int
      getNext i current =
        let offsets = V.map (\x -> getOffset i x) surrounding
            totals = V.map (\x -> (v V.! x)) offsets
            total = V.foldl (+) 0 totals
        in if current==1 then (case total of 2 -> 1
                                             3 -> 1
                                             _ -> 0)
          else (case total of 3 -> 1
                              _ -> 0)
  in V.zipWith getNext (V.enumFromN 0 (V.length v)) $ v


run :: Grid -> Int -> Grid
run agrid 0 = agrid
run agrid n =
  let next = iter agrid
  in run next (n - 1)

d = run startGrid 100000
result = (gridToStr startGrid) ++ "\n" ++ (gridToStr d)
