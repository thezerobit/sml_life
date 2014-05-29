import System.Collections.Generic

def sum(ints as IEnumerable[of int]):
    i = 0
    for val in ints:
        i = i + val
    return i

def mod(x as int, y as int):
    result = x % y
    if result < 0:
        return result + y
    return result

struct Grid:
    def constructor(_v as (int), _w as int, _h as int):
        v = _v
        w = _w
        h = _h

    v as (int)
    w as int
    h as int

def print_enum(en):
    print "(" + join(en, ", ") + ")"

def print_grid(g as Grid):
    def print_slice(n as int):
        if n < g.h:
            print_enum(g.v[n*g.w:(n*g.w)+g.w])
            print_slice(n + 1)
    print_slice(0)

def iter_(g as Grid):
    v as (int) = g.v
    w = g.w
    h = g.h
    surrounding = [(-1,-1), (0,-1), (1,-1),
                   (-1, 0),         (1, 0),
                   (-1, 1), (0, 1), (1, 1)]
    def get_offset(current as int, x as int, y as int):
        dest_x = mod((current + x), w)
        dest_y = mod((current / w) + y,  w)
        return dest_y * w + dest_x
    def get_next(i as int, current as int):
        offsets = map(surrounding, {s as (int) | get_offset(i, s[0],s[1])})
        totals = v[x] for x as int in offsets
        total = sum(totals)
        if current == 1:
            if total in (2,3):
                return 1
            else:
                return 0
        else:
            if total == 3:
                return 1
            else:
                return 0
    arr = array(int, map(range(len(v)), { i as int | get_next(i, v[i])})) as (int)
    return Grid(arr, w, h)

def run_(grid as Grid, n as int):
    local_g as Grid = grid
    for x in range(n):
        local_g = iter_(local_g)
    return local_g

g_grid = Grid(
  (0,0,0,0,0,
   0,1,1,1,0,
   0,1,0,0,0,
   0,0,1,0,0,
   0,0,0,0,0), 5, 5)

print_grid(g_grid)

d = run_(g_grid, 100000)
print_grid(d)
