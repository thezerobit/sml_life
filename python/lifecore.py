def print_slice(n, v, w, h):
    if n >= h:
        print ""
    else:
        for x in v[n*w:(n*w)+w]:
            print x,
        print ""
        print_slice(n + 1, v, w, h)

def print_grid(g):
    (v,w,h) = g
    print_slice(0, v, w, h)

def get_offset(current, x, y, w):
    dest_x = (current + x) % w
    dest_y = ((current / w) + y) % w
    return dest_y * w + dest_x

surrounding = [(-1,-1), (0,-1), (1,-1),
               (-1, 0),         (1, 0),
               (-1, 1), (0, 1), (1, 1)]

def get_next(i, current, v, w):
    offsets = [get_offset(i, s[0], s[1], w) for s in surrounding]
    totals = [v[x] for x in offsets]
    total = 0
    for val in totals:
        total += val
    if current == 1:
        return 1 if total in (2,3) else 0
    else:
        return 1 if total == 3 else 0

def iter_(g):
    (v,w,h) = g
    i = 0
    res = []
    for c in v:
        res.append(get_next(i, c, v, w))
        i += 1
    return (res, w, h)


def run_(grid, n):
    local_g = grid
    for x in range(n):
        local_g = iter_(local_g)
    return local_g


def main(argv):
    print "start"

    g_grid = (
        [0,0,0,0,0,
         0,1,1,1,0,
         0,1,0,0,0,
         0,0,1,0,0,
         0,0,0,0,0], 5, 5)

    print_grid(g_grid)
    d = run_(g_grid, 100000)
    print_grid(d)

    print "end"

    return 0
 
