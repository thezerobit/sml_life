module Main where
main = putStrLn result

type Grid = ([Int], Int, Int)

grid = (
  [0,0,0,0,0,
   0,1,1,1,0,
   0,1,0,0,0,
   0,0,1,0,0,
   0,0,0,0,0], 5, 5) :: Grid

cellToChar 0 = '0'
cellToChar 1 = '1'

gridToStr :: Grid -> [Char]
gridToStr ([], w, h) = []
gridToStr (v, w, h) = [ cellToChar x | x <- (take w v) ] ++ "\n" ++
  gridToStr (drop w v, w, h)

iter :: Grid -> Grid
iter (v, w, h) =
  let surrounding = [(-1,-1), (0,-1), (1,-1),
                     (-1, 0),         (1, 0),
                     (-1, 1), (0, 1), (1, 1)]
      getOffset :: Int -> (Int, Int) -> Int
      getOffset current (x, y) =
        let destX = (current + x) `mod` w
            destY = ((current `div` w) + y) `mod` h
        in destY * w + destX
      getNext :: Int -> Int -> Int
      getNext i current =
        let offsets = map (\x -> getOffset i x) surrounding
            totals = map (\x -> (v !! x)) offsets
            total = foldl (+) 0 totals
        in if current==1 then (case total of 2 -> 1
                                             3 -> 1
                                             _ -> 0)
          else (case total of 3 -> 1
                              _ -> 0)
   in ((zipWith getNext [0..] v), w, h)

run :: Grid -> Int -> Grid
run agrid 0 = agrid
run agrid n =
  let next = iter agrid
  in run next (n - 1)

d = run grid 100000
result = (gridToStr grid) ++ "\n" ++ (gridToStr d)

