(import-macros {: inspect : defns} :source.lib.macros)

(defns :Menu
  [{:player player-ent} (require :source.game.entities.core)
      scene-manager (require :source.lib.scene-manager)
      $ui (require :source.lib.ui)
      pd playdate
      gfx pd.graphics]

  (fn enter! [$]
    ($ui:open-menu!
     {:options [{:text "Level 1" :action #(scene-manager:select! :level0)}
                {:text "About" :action #($ui:open-textbox! {:text (gfx.getLocalizedText "textbox.about")})}
                ]}))

  (fn exit! [$]
    (tset $ :state {}))

  (fn tick! [$scene]
    (if (playdate.buttonJustPressed playdate.kButtonA)
        (scene-manager:select! :level0)))

  (fn draw! [$scene]
    )
  )

