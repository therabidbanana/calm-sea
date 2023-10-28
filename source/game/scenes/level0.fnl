(import-macros {: pd/import : defns : inspect : clamp} :source.lib.macros)
(import-macros {: deflevel} :source.lib.ldtk.macros)

(deflevel :Level_0
  [{: player-hud} (require :source.game.entities.core)
   scene-manager (require :source.lib.scene-manager)
   level-builder (require :source.game.scenes.level-builder)
   $ui (require :source.lib.ui)
   pd playdate
   gfx pd.graphics]

  (fn enter! [$]
    (let [state (level-builder.prepare-level! Level_0)
          ;; far-bg (gfx.sprite.new (-> (gfx.image.new :assets/images/shimmer3)
          ;;                            (: :fadedImage 0.2 gfx.image.kDitherTypeAtkinson)))
          ;; far-bg2 (gfx.sprite.new (-> (gfx.image.new :assets/images/shimmer2)
          ;;                             (: :fadedImage 0.2 gfx.image.kDitherTypeAtkinson))
          ;;                         )

          all-tiles {
           :tiles-1 (gfx.imagetable.new :assets/images/tiles-1)
           :tiles-2 (gfx.imagetable.new :assets/images/tiles-2)
           :tiles-3 (gfx.imagetable.new :assets/images/tiles-3)
           :tiles-4 (gfx.imagetable.new :assets/images/tiles-4)
           :tiles-5 (gfx.imagetable.new :assets/images/tiles-5)
           }
          on-treasure (fn [_type] (scene-manager:select! :menu))
          ]
      (tset $ :state state)
      (tset state :player :state :on-treasure on-treasure)
      (tset $ :all-tiles all-tiles)
      (tset $ :curr-tiles :tiles-1)
      ;; (tset $ :far-bg far-bg)
      ;; (tset $ :far-bg2 far-bg2)
      ;; (far-bg:moveTo 0 100)
      ;; (far-bg:setZIndex -101)
      ;; (far-bg2:moveTo 110 110)
      ;; (far-bg2:setZIndex -102)
      ;; (far-bg:setIgnoresDrawOffset true)
      ;; (far-bg2:setIgnoresDrawOffset true)
      ;; (far-bg:add)
      ;; (far-bg2:add)
      (: (player-hud.new! $.state.player) :add)
      ;; (printTable (ldtk.load-level {:level 0}))
      )
    )

  (fn exit! [$]
    (tset $ :state {})
    (gfx.setDrawOffset 0 0)
    )

  (fn tick! [{: state &as $scene}]
    (level-builder.tick-level! $scene)
    (let [tile-num (+ (% (// state.ticks 30) 5) 1)
          tileset (.. "tiles-" tile-num)]
      (if (not= $scene.curr-tiles tileset)
          (do
            (tset $scene :curr-tiles tileset)
            (state.tiles.tilemap:setImageTable (. $scene.all-tiles tileset))
            (state.tiles.sprite:markDirty)))
      )


    ;; Handle ocean wave effect
    ;; ($scene.far-bg:moveBy (+ (* 0.3 (math.cos (// state.ticks 40))) (* -0.2 state.player.state.dx))
    ;;                       (+ (* 0.25 (math.sin (// state.ticks 40))) (* -0.2 state.player.state.dy)))
    ;; ($scene.far-bg2:moveBy (* -0.3 (math.cos (// state.ticks 40))) (* -0.1 state.player.state.dy))
    ;; 
    )

  (fn draw! [$]
    ;; ($.layer.tilemap:draw 0 0)
    )
  )

