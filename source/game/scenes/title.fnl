(import-macros {: pd/import : defns : inspect} :source.lib.macros)

(defns :TitleScreen
  [$ui (require :source.lib.ui)
   scene-manager (require :source.lib.scene-manager)
   pd playdate
   gfx pd.graphics]

  (fn enter! [$]
    )

  (fn exit! [$]
    )

  (fn tick! [$]
    (if ($ui:active?) ($ui:tick!)

        (playdate.buttonJustPressed playdate.kButtonA)
        (scene-manager:select! :level0))
    )
  (fn draw! [$]
    ;; ($.layer.tilemap:draw 0 0)
    )
  )

