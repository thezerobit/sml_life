#lang typed/racket

(: vector-mapi ((Integer Integer -> Integer) (Vectorof Integer) -> (Vectorof Integer)))
(define (vector-mapi fn v)
  (let*: ([len : Integer (vector-length v)]
         [fresh : (Vectorof Integer) (make-vector len 0)])
    (letrec: ((internal : (Integer -> Void)
              (lambda (i)
                (when (< i len)
                    (begin
                      (vector-set! fresh i (fn i (vector-ref v i)))
                      (internal (+ i 1)))))))
      (internal 0)
      fresh)))

(: fold ((Integer Integer -> Integer) Integer (Listof Integer) -> Integer))
(define (fold fn nil lst)
  (if (null? lst)
    nil
    (fold fn (fn nil (car lst)) (cdr lst))))

(: subvector ((Vectorof Integer) Integer Integer -> (Vectorof Integer)))
(define (subvector v start end)
  (let* ((len (- end start))
         (newvec (make-vector len)))
    (letrec: ((ins : (Integer -> Void)
                (lambda (i)
                  (when (< i end)
                    (begin
                      (vector-set! newvec (- i start) (vector-ref v i))
                      (ins (+ i 1)))))))
      (ins start)
      newvec)))

(struct: lifegrid ([v : (Vectorof Integer)] [w : Integer] [h : Integer]))

(: grid lifegrid)
(define grid (lifegrid
  (vector 0 0 0 0 0
          0 1 1 1 0
          0 1 0 0 0
          0 0 1 0 0
          0 0 0 0 0) 5 5))

(: print-grid (lifegrid -> Void))
(define (print-grid g)
  (let ((v (lifegrid-v g))
        (w (lifegrid-w g))
        (h (lifegrid-h g)))
    (letrec: ((print-slice : (Integer -> Void)
                (lambda (n)
                  (if (>= n h)
                    (newline)
                    (begin
                      (let ((slice (subvector v (* n w) (+ (* n w) w))))
                        (map (lambda (x) (display x)) (vector->list slice)))
                      (newline)
                      (print-slice (+ n 1)))))))
      (print-slice 0))))

(define-type Coord (List Integer Integer))
(define-type CoordList (Listof Coord))

(: iter (lifegrid -> lifegrid))
(define (iter g)
  (let: ((v : (Vectorof Integer) (lifegrid-v g))
         (w : Integer (lifegrid-w g))
         (h : Integer (lifegrid-h g))
         (surrounding : CoordList
           '((-1 -1) (0 -1) (1 -1)
             (-1  0)        (1  0)
             (-1  1) (0  1) (1  1))))
    (letrec: ((get-offset : (Integer Coord -> Integer)
                (lambda (current cs)
                  (let* ((x (car cs))
                         (y (cadr cs))
                         (dest-x (modulo (+ current x) w))
                         (dest-y (modulo (+ (quotient current w) y) h)))
                    (+ (* dest-y w) dest-x))))
              (get-next : (Integer Integer -> Integer)
                (lambda (i current)
                  (let* ((offsets (map (lambda: ([x : Coord])
                                         (get-offset i x)) surrounding))
                         (totals (map (lambda: ([x : Integer])
                                        (vector-ref v x)) offsets))
                         (total (fold + 0 totals)))
                    (if (= current 1)
                      (if (or (= total 2) (= total 3)) 1 0)
                      (if (= total 3) 1 0))))))
      (lifegrid (vector-mapi get-next v) w h))))

(: run (lifegrid Integer -> lifegrid))
(define (run lgrid n)
  (if (= n 0)
    lgrid
    (let ((next (iter lgrid)))
      (run next (- n 1)))))

(print-grid grid)
(let ((d (run grid 100000)))
  (print-grid d))

