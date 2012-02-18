(define (vector-mapi fn v)
  (letrec ((len (vector-length v))
           (fresh (make-vector len))
           (internal
             (lambda (i)
               (if (< i len)
                   (begin
                     (vector-set! fresh i (fn i (vector-ref v i)))
                     (internal (+ i 1)))))))
    (internal 0)
    fresh))

(define (vector-do fn v)
  (map fn (vector->list v)))

(define (fold fn nil lst)
  (if (null? lst)
    nil
    (fold fn (fn nil (car lst)) (cdr lst))))

(define (subvector v start end)
  (letrec ((len (- end start))
           (newvec (make-vector len))
           (ins (lambda (i)
                  (if (< i end)
                    (begin 
                      (vector-set! newvec (- i start) (vector-ref v i))
                      (ins (+ i 1)))))))
    (ins start)
    newvec))

(define grid (vector
  (vector 0 0 0 0 0
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
                     (let ((slice (subvector v (* n w) (+ (* n w) w))))
                       (vector-do (lambda (x) (display x)) slice))
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
                    (totals (map (lambda (x) (vector-ref v x)) offsets))
                    (total (fold + 0 totals)))
               (if (= current 1)
                 (if (or (= total 2) (= total 3)) 1 0)
                 (if (= total 3) 1 0))))))
    (vector (vector-mapi get-next v) w h)))

(define (run lgrid n)
  (if (= n 0)
    lgrid
    (let ((next (iter lgrid)))
      (run next (- n 1)))))

(print-grid grid)
(let ((d (run grid 100000)))
  (print-grid d))

