(import-macros {: pd/import : defns : inspect} :source.lib.macros)

(defns :TitleScreen
  [$ui (require :source.lib.ui)
   scene-manager (require :source.lib.scene-manager)
   pd playdate
   gfx pd.graphics]

  (fn enter! [$]
    (let [img (gfx.image.new :assets/images/title)
          _ (gfx.pushContext)
          _ (gfx.setImageDrawMode gfx.kDrawModeFillWhite)
          a-to-start (gfx.imageWithText "Ⓐ to Start" 100 100 gfx.kColorBlack)
          _ (gfx.popContext)
          ;; start (gfx.sprite.new a-to-start)
          ]
      (tset $ :state {})
      (tset $ :state :bg-anim (playdate.graphics.animator.new 2500 0 1 playdate.easingFunctions.inCubic))
      (tset $ :state :start-anim (playdate.graphics.animator.new 1500 0 1 playdate.easingFunctions.outCubic 2500))
      (tset $ :state :bg img)
      (tset $ :state :start a-to-start)
      ;; (start:moveTo 200 210)
      ;; (start:setZIndex 100)
      ;; (start:add)
      )
    )

  (fn exit! [$]
    (tset $ :state {})
    )

  (fn tick! [$]
    (if ($ui:active?) ($ui:tick!)

        (playdate.buttonJustPressed playdate.kButtonA)
        (scene-manager:select! :menu))
    )
  (fn draw! [$]
    (gfx.clear)
    ($.state.bg:drawFaded 0 0 ($.state.bg-anim:currentValue) gfx.image.kDitherTypeFloydSteinberg)
    ($.state.start:drawFaded 150 200 ($.state.start-anim:currentValue) gfx.image.kDitherTypeFloydSteinberg)

    ;; ($.layer.tilemap:draw 0 0)
    )
  )

