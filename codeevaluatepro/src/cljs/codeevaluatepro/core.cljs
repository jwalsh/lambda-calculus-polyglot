(ns codeevaluatepro.core
  (:require [reagent.dom :as rdom]
            [re-frame.core :as rf]
            [codeevaluatepro.components.grader-interface :refer [grader-interface]]
            [codeevaluatepro.models :as models]))

(rf/reg-event-db
 :initialize-db
 (fn [_ _]
   models/initial-db))

(rf/reg-sub
 :logs
 (fn [db]
   (:logs db)))

(rf/reg-sub
 :grading-criteria
 (fn [db]
   (:grading-criteria db)))

(rf/reg-sub
 :current-code
 (fn [db]
   (:current-code db)))

(rf/reg-event-db
 :update-criterion-score
 (fn [db [_ criterion-name new-score]]
   (update-in db [:grading-criteria]
              (fn [criteria]
                (map #(if (= (:name %) criterion-name)
                        (assoc % :score (js/parseInt new-score))
                        %)
                     criteria)))))

(rf/reg-event-fx
 :submit-evaluation
 (fn [{:keys [db]} _]
   {:db db
    :dispatch [:send-evaluation-to-server]}))

(defn mount-root []
  (rf/clear-subscription-cache!)
  (let [root-el (.getElementById js/document "app")]
    (rdom/unmount-component-at-node root-el)
    (rdom/render [grader-interface] root-el)))

(defn ^:export init! []
  (rf/dispatch-sync [:initialize-db])
  (mount-root))
