(ns codeevaluatepro.models)

(def initial-db
  {:logs [{:id 1 :timestamp "2024-07-29 10:00:00" :content "Evaluation started"}
          {:id 2 :timestamp "2024-07-29 10:05:00" :content "Code submitted"}]
   :grading-criteria [{:name "Correctness" :description "Does the code produce the correct output?" :score 0 :max-score 10}
                      {:name "Efficiency" :description "Is the code optimized and efficient?" :score 0 :max-score 10}
                      {:name "Style" :description "Does the code follow good coding practices?" :score 0 :max-score 10}]
   :current-code "def hello_world():\n    print('Hello, World!')"})
