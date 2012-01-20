A simple, naive implementation of Conway's Game of Life in
Standard ML and Python 2.7.

These are not optimal or well-formed solutions to this problem.
They are just the first thing I hacked up. I am just learning
Standard ML, and the Python implementation is pretty much
a direct port of the Standard ML code with minor changes.

Here are the benchmark results for 100000 iterations of life on
a small, 5x5 grid with a little glider flying alone:

Standard ML compiled with MLton:

0.716 seconds

Python run with CPython 2.7.2:

26.808 seconds

Python run with PyPy 1.7:

6.415 seconds

So the SML/MLton version is about 9 times faster than PyPy and 37
times faster than CPython.
