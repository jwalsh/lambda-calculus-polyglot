(ns codeevaluatepro.components.grading-rubric
  (:require [reagent.core :as r]
            [re-frame.core :as rf]))

(defn grading-criterion [{:keys [name description score max-score]}]
  [:div.criterion
   [:h3 name]
   [:p description]
   [:input {:type "number"
            :min 0
            :max max-score
            :value score
            :on-change #(rf/dispatch [:update-criterion-score name (.. % -target -value)])}]])

(defn grading-rubric []
  (let [criteria @(rf/subscribe [:grading-criteria])]
    [:div.grading-rubric
     (for [criterion criteria]
       ^{:key (:name criterion)}
       [grading-criterion criterion])]))
