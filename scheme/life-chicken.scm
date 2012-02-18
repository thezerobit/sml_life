(require-extension srfi-1)
(require-extension srfi-4)

(define (s32vector-mapi fn v)
  (letrec ((len (s32vector-length v))
           (fresh (make-s32vector len))
           (internal
             (lambda (i)
               (if (< i len)
                   (begin
                     (s32vector-set! fresh i (fn i (s32vector-ref v i)))
                     (internal (+ i 1)))))))
    (internal 0)
    fresh))

(define (s32vector-do fn v)
  (map fn (s32vector->list v)))

(define grid (vector
  (s32vector 0 0 0 0 0
             0 1 1 1 0
             0 1 0 0 0
             0 0 1 0 0
             0 0 0 0 0) 5 5))

(define (print-grid g)
  (let ((v (vector-ref g 0))
        (w (vector-ref g 1))
        (h (vector-ref g 2)))
    (letrec ((print-slice
               (lambda (n)
                 (if (>= n h)
                   (newline)
                   (begin
                     (let ((slice (subs32vector v (* n w) (+ (* n w) w))))
                       (s32vector-do (lambda (x) (display x)) slice))
                     (newline)
                     (print-slice (+ n 1)))))))
      (print-slice 0))))

(define (iter g)
  (let* ((v (vector-ref g 0))
         (w (vector-ref g 1))
         (h (vector-ref g 2))
         (surrounding '((-1 -1) (0 -1) (1 -1)
                        (-1  0)        (1  0)
                        (-1  1) (0  1) (1  1)))
         (get-offset
           (lambda (current cs)
             (let* ((x (car cs))
                    (y (cadr cs))
                    (dest-x (modulo (+ current x) w))
                    (dest-y (modulo (+ (quotient current w) y) h)))
               (+ (* dest-y w) dest-x))))
         (get-next
           (lambda (i current)
             (let* ((offsets (map (lambda (x) (get-offset i x)) surrounding))
                    (totals (map (lambda (x) (s32vector-ref v x)) offsets))
                    (total (fold + 0 totals)))
               (if (= current 1)
                 (if (or (= total 2) (= total 3)) 1 0)
                 (if (= total 3) 1 0))))))
    (vector (s32vector-mapi get-next v) w h)))

(define (run lgrid n)
  (if (= n 0)
    lgrid
    (let ((next (iter lgrid)))
      (run next (- n 1)))))

(print-grid grid)
(let ((d (run grid 100000)))
  (print-grid d))

