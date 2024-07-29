(ns codeevaluatepro.components.example-log-entry
  (:require [reagent.core :as r]
            [re-frame.core :as rf]))

(defn example-log-entry [{:keys [timestamp content]}]
  [:div.log-entry
   [:span.timestamp timestamp]
   [:p.content content]])

(defn example-log-list []
  (let [logs @(rf/subscribe [:logs])]
    [:div.log-list
     (for [log logs]
       ^{:key (:id log)}
       [example-log-entry log])]))
