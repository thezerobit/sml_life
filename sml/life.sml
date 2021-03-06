
type life_grid = int Vector.vector * int * int

val grid = (Vector.fromList
  [0,0,0,0,0,
   0,1,1,1,0,
   0,1,0,0,0,
   0,0,1,0,0,
   0,0,0,0,0], 5, 5)

fun print_grid (v, w, h) =
let
  fun print_slice n =
    if n >= h then print "\n"
    else
      let
        val _ = VectorSlice.map (fn x:int => print (Int.toString x))
          (VectorSlice.slice (v, n*w, SOME w))
        val _ = print "\n"
      in
        print_slice (n + 1)
      end
in
  print_slice 0
end

fun iter (v : int Vector.vector, w : int, h : int) =
let
  val surrounding = Vector.fromList[(~1,~1), (0,~1), (1,~1),
                                    (~1, 0),         (1, 0),
                                    (~1, 1), (0, 1), (1, 1)]
  fun get_offset (current:int, (x:int, y:int)) =
  let
    val dest_x = (current + x) mod w
    val dest_y = ((current div w) + y) mod h
  in
    dest_y * w + dest_x
  end
  fun get_next (i:int, current:int) =
  let
    val offsets = Vector.map (fn x => get_offset (i, x)) surrounding
    val totals = Vector.map (fn x => Vector.sub (v, x)) offsets
    val total = Vector.foldl (op +) 0 totals
  in
    if current=1 then (case total of 2 => 1 | 3 => 1 | _ => 0)
    else (case total of 3 => 1 | _ => 0)
  end
in
    (Vector.mapi get_next v, w, h)
end;

val _ = print_grid grid

fun run (grid:life_grid, 0) = grid
  | run (grid, n) =
  let
    val next = iter grid
  in
    run (next, n-1)
  end;

val d = run (grid, 100000)
val _ = print_grid d
