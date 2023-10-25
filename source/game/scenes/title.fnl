(import-macros {: pd/import : defns : inspect} :source.lib.macros)

(defns :TitleScreen
  [$ui (require :source.lib.ui)
   scene-manager (require :source.lib.scene-manager)
   pd playdate
   gfx pd.graphics]

  (fn enter! [$]
    (let [img (gfx.image.new :assets/images/title)
          bg (gfx.sprite.new img)
          _ (gfx.setImageDrawMode gfx.kDrawModeFillWhite)
          a-to-start (gfx.imageWithText "Ⓐ to Start" 100 100 gfx.kColorBlack)
          start (gfx.sprite.new a-to-start)
          ]
      (bg:setCenter 0 0)
      (bg:moveTo 0 0)
      (bg:setZIndex -100)
      (bg:add)
      (start:moveTo 200 210)
      (start:setZIndex 100)
      (start:add)
      ))

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

