(import-macros {: inspect : defns} :source.lib.macros)

(defns scene
  [{:player player-ent} (require :source.game.entities.core)
      scene-manager (require :source.lib.scene-manager)
      $ui (require :source.lib.ui)
      pd playdate
      gfx pd.graphics]

  (fn enter! [$]
    ($ui:open-menu!
     {:options [{:text "Foo" :action #($ui:open-textbox! {:text (gfx.getLocalizedText "textbox.test2") :nametag "Picarding"})}
                {:text "Bar [!]" :action #(scene-manager:select! :title)}
                {:text "Quux" :action #($ui:open-textbox! {:text (gfx.getLocalizedText "textbox.test2")})}
                {:text "Qux" :keep-open? true}
                {:text "Corge"}
                {:text "Grault"}
                {:text "Garply"}
                ]}))

  (fn exit! [$]
    (tset $ :state {}))

  (fn tick! [$scene]
    (if ($ui:active?) ($ui:tick!)

     (playdate.buttonJustPressed playdate.kButtonA)
     (scene-manager:select! :title)))

  (fn draw! [$scene]
    ($ui:render!)
    )
  )

