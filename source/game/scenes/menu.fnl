(import-macros {: inspect : defns} :source.lib.macros)

(defns :Menu
  [{: treasure } (require :source.game.entities.core)
      scene-manager (require :source.lib.scene-manager)
      $ui (require :source.lib.ui)
      pd playdate
      gfx pd.graphics]

  (fn set-treasures [$ treasures]
    (if treasures
        (let [_ (gfx.sprite.removeAll)
              sprites (icollect [idx _type (ipairs treasures)]
                        (let [treasure-type (if (?. $treasures _type) _type :unknown)]
                          (doto (treasure.new! (+ 240 (math.random 40)) (+ (* 70 idx) (math.random 20)) treasure-type true) (: :add))))]
          (tset $.state :treasures treasures)
          (if (> 0 (length sprites))
              (tset $.state :sprites sprites)
              (tset $.state :sprites nil)
              )
          )
        (do (gfx.sprite.removeAll)
            (tset $.state :treasures nil)
            (tset $.state :sprites nil))))

  (fn enter! [$]
    (tset $ :state {})
    ($ui:open-menu!
     {:on-draw (fn [comp selected]
                 (if (not= selected.treasures $.state.treasures)
                     ($:set-treasures selected.treasures))
                 (gfx.sprite.performOnAllSprites
                  (fn react-each [ent]
                    (if (?. ent :react!) (ent:react! $scene))))


                 (gfx.sprite.update)
                 ;; (printTable selected)
                 )
      :options [{:text "About" :keep-open? true
                 :action #($ui:open-textbox! {:text (gfx.getLocalizedText "textbox.about")})}
                {:treasures [:fork]
                 :text "First Dive" :action #(scene-manager:select! :level0)}
                {:treasures [:coin]
                 :text "Jelly Playground" :action #(scene-manager:select! :level1)}
                {:treasures [:gem]
                 :text "Seaweed Cave" :action #(scene-manager:select! :level2)}
                {:treasures [:necklace]
                 :text "Shark Haven" :action #(scene-manager:select! :level3)}
                {:treasures [:crown]
                 :text "The Reef" :action #(scene-manager:select! :level4)}
                ]}))

  (fn exit! [$]
    (tset $ :state {}))

  (fn tick! [$scene]
    (if (playdate.buttonJustPressed playdate.kButtonA)
        (scene-manager:select! :level0))
    )

  (fn draw! [$scene]
    )
  )

