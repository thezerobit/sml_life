
val s = Vector.fromList [0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

fun print_vector v =
  Vector.map (fn x:int => print ((Int.toString x) ^ " ")) v

fun iter (v : int Vector.vector, w : int, h : int) =
let
    val offsets = Vector.fromList[0-w-1,0-w,0-w+1,~1,1,w-1,w,w+1]
    val length = w*h
    fun get_next (i:int, current:int) =
      let
        val totals = Vector.map (fn x => Vector.sub (v, ((i+x) mod length)))
          offsets
        val total = Vector.foldl (op +) 0 totals
      in
        if current=1 then (case total of 2 => 1 | 3 => 1 | _ => 0)
        else (case total of 3 => 1 | _ => 0)
      end
in
    Vector.mapi get_next v
end;

val _ = print_vector s
val _ = print "\n"
val n = iter (s,5,5)
val _ = print_vector n
val _ = print "\n"
