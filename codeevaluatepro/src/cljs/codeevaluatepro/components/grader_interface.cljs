(ns codeevaluatepro.components.grader-interface
  (:require [reagent.core :as r]
            [re-frame.core :as rf]
            [codeevaluatepro.components.grading-rubric :refer [grading-rubric]]
            [codeevaluatepro.components.example-log-entry :refer [example-log-list]]))

(defn grader-interface []
  [:div.grader-interface
   [:h1 "Code Evaluation Pro"]
   [:div.code-display
    [:h2 "Student Code"]
    [:pre [:code @(rf/subscribe [:current-code])]]]
   [grading-rubric]
   [example-log-list]
   [:button {:on-click #(rf/dispatch [:submit-evaluation])} "Submit Evaluation"]])
