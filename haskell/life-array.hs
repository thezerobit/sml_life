module Main where
import Data.Array.Unboxed
main = putStrLn result

type GridArray = UArray Int Int
type Grid = (GridArray, Int, Int)

gridArrayFromList :: [Int] -> GridArray
gridArrayFromList v = listArray (0, (length v) - 1) v

startGrid = (
  gridArrayFromList [0,0,0,0,0,
                     0,1,1,1,0,
                     0,1,0,0,0,
                     0,0,1,0,0,
                     0,0,0,0,0], 5, 5) :: Grid

cellToChar 0 = '0'
cellToChar 1 = '1'

gridListToStr :: ([Int], Int, Int) -> [Char]
gridListToStr ([], w, h) = []
gridListToStr (v, w, h) = [ cellToChar x | x <- (take w v) ] ++ "\n" ++
  gridListToStr (drop w v, w, h)

gridToStr :: Grid -> [Char]
gridToStr (ga, w, h) = gridListToStr (elems ga, w, h)

iter :: Grid -> Grid
iter (v, w, h) =
  let surrounding = [(-1,-1), (0,-1), (1,-1),
                     (-1, 0),         (1, 0),
                     (-1, 1), (0, 1), (1, 1)]
      getOffset :: (Int, (Int, Int)) -> Int
      getOffset (current, (x, y)) =
        let destX = (current + x) `mod` w
            destY = ((current `div` w) + y) `mod` h
        in destY * w + destX
      getNext (i, current) =
        let offsets = map (\x -> getOffset (i, x)) surrounding
            totals = map (\x -> (v ! x)) offsets
            total = foldl (+) 0 totals
        in if current==1 then (case total of 2 -> 1
                                             3 -> 1
                                             _ -> 0)
          else (case total of 3 -> 1
                              _ -> 0)
  in (gridArrayFromList (map (\(x,i) -> getNext (i, x)) (zip (elems v) [0..])),
    w, h)

run :: (Grid, Int) -> Grid
run (agrid, 0) = agrid
run (agrid, n) =
  let next = iter agrid
  in run (next, (n - 1))

d = run (startGrid, 100000)
result = (gridToStr startGrid) ++ "\n" ++ (gridToStr d)

