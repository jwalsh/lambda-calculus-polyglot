(defproject codeevaluatepro "0.1.0-SNAPSHOT"
  :description "CodeEvaluatePro - A tool for evaluating code"
  :url "https://wal.sh/CodeEvaluatePro"
  :license {:name "MIT License"
            :url "https://opensource.org/licenses/MIT"}
  :author "Jason Walsh <j@wal.sh>"

  :dependencies [[org.clojure/clojure "1.11.1"]
                 [org.clojure/clojurescript "1.11.60"]
                 [reagent "1.1.1"]
                 [re-frame "1.2.0"]
                 [compojure "1.6.3"]
                 [yogthos/config "1.2.0"]
                 [ring "1.9.5"]
                 [org.slf4j/slf4j-nop "1.7.30"]
                 [hawk "0.2.11"]]  ; Add Hawk for file watching

  :plugins [[lein-cljsbuild "1.1.8"]
            [lein-figwheel "0.5.20"]]

  :source-paths ["src/clj" "src/cljs" "src/cljc"]

  :clean-targets ^{:protect false} ["resources/public/js/compiled" "target"]

  :figwheel {:css-dirs ["resources/public/css"]
             :hawk-options {:watcher :polling}}  ; Use polling instead of native file watching

  :cljsbuild
  {:builds
   [{:id           "dev"
     :source-paths ["src/cljs" "src/cljc"]
     :figwheel     {:on-jsload "codeevaluatepro.core/mount-root"}
     :compiler     {:main                 codeevaluatepro.core
                    :output-to            "resources/public/js/compiled/app.js"
                    :output-dir           "resources/public/js/compiled/out"
                    :asset-path           "js/compiled/out"
                    :source-map-timestamp true
                    :preloads             [devtools.preload]
                    :external-config      {:devtools/config {:features-to-install :all}}}}

    {:id           "min"
     :source-paths ["src/cljs" "src/cljc"]
     :compiler     {:main            codeevaluatepro.core
                    :output-to       "resources/public/js/compiled/app.js"
                    :optimizations   :advanced
                    :closure-defines {goog.DEBUG false}
                    :pretty-print    false}}]}

  :profiles
  {:dev
   {:dependencies [[binaryage/devtools "1.0.6"]
                   [figwheel-sidecar "0.5.20"]]

    :source-paths ["env/dev/clj"]}}

  :aliases {"fig"      ["trampoline" "run" "-m" "figwheel.main"]
            "fig:build" ["run" "-m" "figwheel.main" "-b" "dev" "-r"]
            "fig:min"   ["run" "-m" "figwheel.main" "-O" "advanced" "-bo" "min"]})
