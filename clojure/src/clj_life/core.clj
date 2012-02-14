(ns clj-life.core)

(def grid [
  [0 0 0 0 0
   0 1 1 1 0
   0 1 0 0 0
   0 0 1 0 0
   0 0 0 0 0] 5 5])

(defn print-grid [[v w h]]
  (let [print-slice
        (fn [n]
          (if (>= n h)
            (print "\n")
            (do
              (doseq [x (take w (drop (* n w) v))]
                (pr x))
              (print "\n")
              (recur (inc n)))))]
    (print-slice 0)))

(defn iter [[v w h]]
  (let [surrounding [[-1 -1] [0 -1] [1 -1]
                     [-1  0]        [1  0]
                     [-1  1] [0  1] [1  1]]
        get-offset (fn [current [x y]]
                     (let [dest-x (mod (+ current x) w)
                           dest-y (mod (+ (unchecked-divide-int current w) y) h)]
                       (+ (* dest-y w) dest-x)))
        get-next (fn [i current]
                   (let [offsets (map (fn [x] (get-offset i x)) surrounding)
                         totals (map (fn [x] (get v x)) offsets)
                         total (reduce + totals)]
                     (if (= current 1)
                       (if (or (= total 2) (= total 3)) 1 0)
                       (if (= total 3) 1 0))))]
    [(vec (map-indexed get-next v)) w h]))

(defn run [lgrid n]
  (if (= n 0)
    lgrid
    (let [nxt (iter lgrid)]
      (recur nxt (dec n)))))

(defn -main [& args]
  (time
    (do
      (print-grid grid)
      (let [d (run grid 100000)]
        (print-grid d)))))

