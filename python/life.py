
from __future__ import print_function
def prn(x): print(x, end='')

g_grid = (
  [0,0,0,0,0,
   0,1,1,1,0,
   0,1,0,0,0,
   0,0,1,0,0,
   0,0,0,0,0], 5, 5)

def print_grid(g):
    (v,w,h) = g
    def print_slice(n):
        if n >= h:
            prn("\n")
        else:
            map(lambda x: prn(x), v[n*w:(n*w)+w])
            prn("\n")
            print_slice(n + 1)
    print_slice(0)

def iter_(g):
    (v,w,h) = g
    surrounding = [(-1,-1), (0,-1), (1,-1),
                   (-1, 0),         (1, 0),
                   (-1, 1), (0, 1), (1, 1)]
    def get_offset(current, x, y):
        dest_x = (current + x) % w
        dest_y = ((current / w) + y) % w
        return dest_y * w + dest_x
    def get_next(i, current):
        offsets = map(lambda s : get_offset(i, s[0],s[1]), surrounding)
        totals = map(lambda x : v[x], offsets)
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
    return (map( lambda i, c : get_next(i,c), range(len(v)), v),
            w,h)

print_grid(g_grid)

def run_(grid, n):
    local_g = grid
    for x in range(n):
        local_g = iter_(local_g)
    return local_g

d = run_(g_grid, 100000)
print_grid(d)
