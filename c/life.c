#include "gc.h"
#include <stdio.h>

struct lifegrid {
  int w;
  int h;
  int *v;
};

typedef struct lifegrid * p_lifegrid;

void print_slice (int *v, int w) {
  int i;
  for(i = 0; i < w; ++i) {
    printf("%d", v[i]);
  }
  printf("\n");
}

void print_grid (p_lifegrid grid) {
  int w = grid->w;
  int h = grid->h;
  int *v = grid->v;
  int i;
  for(i = 0; i < h; ++i) {
    print_slice(v + w * i, w);
  }
  printf("\n");
}

p_lifegrid make_grid (int w, int h) {
  p_lifegrid new_grid = GC_MALLOC(sizeof(p_lifegrid));
  new_grid->w = w;
  new_grid->h = h;
  new_grid->v = GC_MALLOC(sizeof(int) * w * h);
  return new_grid;
}

int surrounding[8][2] = {{-1, -1}, {0, -1}, {1, -1},
                         {-1,  0},          {1,  0},
                         {-1,  1}, {0,  1}, {1,  1}};

int modulo (int n, int d) {
  while(n < 0) {
    n += d;
  }
  return n % d;
}

int get_offset (int current, int *cs, int w, int h) {
  int x = cs[0];
  int y = cs[1];
  int dest_x = modulo (current + x, w);
  int dest_y = modulo (current / w + y, h);
  return dest_y * w + dest_x;
}

int get_next (int i, int current, int w, int h, int * v) {
  int offsets[8];
  int totals[8];
  int *x;
  int j;
  int total;
  for(j = 0; j < 8; ++j) {
    x = surrounding[j];
    offsets[j] = get_offset(i, x, w, h);
  }
  for(j = 0; j < 8; ++j) {
    totals[j] = v[offsets[j]];
  }
  total = 0;
  for(j = 0; j < 8; ++j) {
    total += totals[j];
  }
  if(current == 1) {
      if(total == 2 || total == 3) {
          return 1;
      } else {
          return 0;
      }
  } else {
      if(total == 3) {
          return 1;
      } else {
          return 0;
      }
  }
}

p_lifegrid iter (p_lifegrid grid) {
  int w = grid->w;
  int h = grid->h;
  int *v = grid->v;
  int i;
  p_lifegrid new_grid = make_grid(w, h);
  for(i = 0; i < (w * h); ++i) {
    new_grid->v[i] = get_next(i, grid->v[i], w, h, v);
  }
  return new_grid;
}

p_lifegrid run (p_lifegrid grid, int n) {
  int i;
  p_lifegrid next = grid;
  for(i = 0; i < n; ++i) {
    next = iter(next);
  }
  return next;
}

int init_elems[] = {0, 0, 0, 0, 0,
                    0, 1, 1, 1, 0,
                    0, 1, 0, 0, 0,
                    0, 0, 1, 0, 0,
                    0, 0, 0, 0, 0};

int main (int argc, char *argv[]) {
  p_lifegrid grid = make_grid(5,5);
  p_lifegrid next;
  grid->v = init_elems;
  print_grid(grid);
  next = run(grid, 100000);
  print_grid(next);

  return 0;
}
