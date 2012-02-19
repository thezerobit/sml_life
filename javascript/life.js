
var grid =[ [0, 0, 0, 0, 0, 
             0, 1, 1, 1, 0,
             0, 1, 0, 0, 0,
             0, 0, 1, 0, 0,
             0, 0, 0, 0, 0], 5, 5];

function printGrid (g) {
    var v = g[0];
    var w = g[1];
    var h = g[2];
    function printSlice (n) {
        if(n >=h) {
            console.log("");
        } else {
            var slice = v.slice(n * w, n * w + w);
            console.log(slice.join(""))
            printSlice(n + 1);
        }
    }
    printSlice(0);
}

function modulo (a, b) {
    var res = a;
    while(res < 0) {
        res += b;
    }
    return res % b;
}

function iter (g) {
    var v = g[0];
    var w = g[1];
    var h = g[2];
    var surrounding = [[-1,-1], [0,-1], [1,-1],
                       [-1, 0],         [1, 0],
                       [-1, 1], [0, 1], [1, 1]];
    function getOffset(current, x, y) {
        var destX = modulo((current + x), w);
        var destY = modulo((~~(current / w) + y), w);
        return destY * w + destX;
    }
    function getNext(i, current) {
        var offsets = surrounding.map(function (s) {
            return getOffset(i, s[0], s[1]);
        });
        var totals = offsets.map(function (x) { 
            return v[modulo(x, w * h)];
        });
        var total = totals.reduce(function (l,r) { return l + r; });
        if(current === 1) {
            if(total === 2 || total === 3) {
                return 1;
            } else {
                return 0;
            }
        } else {
            if(total === 3) {
                return 1;
            } else {
                return 0;
            }
        }
    }
    var i = 0;
    return [v.map(function (c) { return getNext(i++, c); }), w, h];
}

function run(grid, n) {
    var localGrid = grid;
    var i;
    for(i = 0; i < n; ++i) {
        localGrid = iter(localGrid);
    }
    return localGrid;
}

printGrid(grid);
var d = run(grid, 100000);
printGrid(d);

