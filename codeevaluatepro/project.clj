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
                 [com.bhauman/figwheel-main "0.2.18"]
                 [com.bhauman/rebel-readline-cljs "0.1.4"]
                 [org.slf4j/slf4j-nop "1.7.30"]]  ; Add this line to suppress SLF4J warnings

  :plugins [[lein-figwheel "0.5.20"]]

  :source-paths ["src/clj" "src/cljs" "src/cljc"]

  :clean-targets ^{:protect false} ["resources/public/js/compiled" "target"]

  :aliases {"fig"        ["trampoline" "run" "-m" "figwheel.main"]
            "fig:build"  ["trampoline" "run" "-m" "figwheel.main" "-b" "dev" "-r"]
            "fig:min"    ["run" "-m" "figwheel.main" "-O" "advanced" "-bo" "min"]
            "fig:test"   ["run" "-m" "figwheel.main" "-co" "test.cljs.edn" "-m" "codeevaluatepro.test-runner"]}

  :profiles
  {:dev
   {:dependencies [[binaryage/devtools "1.0.6"]]
    :resource-paths ["target"]
    ;; need to add the compiled assets to the :clean-targets
    :clean-targets ^{:protect false} ["resources/public/cljs-out"
                                      "resources/public/js"
                                      :target-path]}})
