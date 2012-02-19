(defun vector-mapi (fn v)
  (let ((i 0))
    (map 'vector (lambda (x) (apply fn (list (- (incf i) 1) x))) v)))

(defparameter *grid* (list
  (vector 0 0 0 0 0
          0 1 1 1 0
          0 1 0 0 0
          0 0 1 0 0
          0 0 0 0 0) 5 5))

(defun print-grid (g)
  (destructuring-bind (v h w) g
    (labels ((print-slice (n)
               (if (>= n h)
                 (format t "~%")
                 (progn
                   (let ((slice (subseq v (* n w) (+ (* n w) w))))
                     (map 'vector (lambda (x) (format t "~a" x)) slice))
                   (format t "~%")
                   (print-slice (+ n 1))))))
      (print-slice 0))))

(defun iter (g)
  (destructuring-bind (v h w) g
    (let ((surrounding '((-1 -1) (0 -1) (1 -1)
                         (-1  0)        (1  0)
                         (-1  1) (0  1) (1  1))))
      (labels
        ((get-offset (current cs)
           (destructuring-bind (x y) cs
             (let* ((dest-x (mod (+ current x) w))
                    (dest-y (mod (+ (truncate current w) y) h)))
               (+ (* dest-y w) dest-x))))
         (get-next (i current)
             (let* ((offsets (map 'list (lambda (x) (get-offset i x)) surrounding))
                    (totals (map 'list (lambda (x) (aref v x)) offsets))
                    (total (reduce #'+ totals)))
               (if (= current 1)
                 (if (or (= total 2) (= total 3)) 1 0)
                 (if (= total 3) 1 0)))))
        (list (vector-mapi #'get-next v) w h)))))

(defun run (lgrid n)
  (if (= n 0)
    lgrid
    (let ((next (iter lgrid)))
      (run next (- n 1)))))

(print-grid *grid*)
(let ((d (run *grid* 100000)))
  (print-grid d))
