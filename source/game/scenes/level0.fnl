(import-macros {: pd/import : defns : inspect : clamp} :source.lib.macros)
(import-macros {: deflevel} :source.lib.ldtk.macros)

(deflevel :Level_0
  [{:player player-ent
    : player-hud
    : treasure
    : shark
    :school school-ent} (require :source.game.entities.core)
   ldtk (require :source.lib.ldtk.loader)
   scene-manager (require :source.lib.scene-manager)
   {: prepare-level} (require :source.lib.level)
   $ui (require :source.lib.ui)
   pd playdate
   gfx pd.graphics]

  (fn enter! [$]
    (let [;; Option 1 - Loads at runtime
          ;; loaded (prepare-level (ldtk.load-level {:level 0}))
          ;; Option 2 - relies on deflevel compiling
          loaded (prepare-level Level_0)
          tile-layers (collect [_ {: layer-id &as l} (ipairs (?. loaded :tile-layers))]
                        (values layer-id l))
          layer (. tile-layers :Tiles)
          wall-layer (. tile-layers :Walls)
          entities (?. loaded :entity-layers 1)
          far-bg (gfx.sprite.new (-> (gfx.image.new :assets/images/shimmer)
                                     (: :fadedImage 0.15 gfx.image.kDitherTypeBurkes)))
          far-bg2 (gfx.sprite.new (-> (gfx.image.new :assets/images/shimmer2)
                                      (: :fadedImage 0.15 gfx.image.kDitherTypeBurkes))
                                  )
          bg (gfx.sprite.new)
          alt-tiles (gfx.imagetable.new :assets/images/tiles1)
          main-tiles (gfx.imagetable.new :assets/images/tiles)
          on-treasure (fn [_type] (scene-manager:select! :menu))
          walls (gfx.sprite.addWallSprites wall-layer.tilemap)]
      (each [_ sprite (ipairs walls)]
        (tset sprite :wall? true)
        (tset sprite :collisionResponse #gfx.sprite.kCollisionTypeSlide)
        (sprite:setGroups [4])
        ;; (sprite:setCollidesWithGroups [1])
        )
      (tset $ :width loaded.w)
      (tset $ :height loaded.h)
      (tset $ :ticks 0)
      (tset $ :bg bg)
      (tset $ :tilemap layer.tilemap)
      (tset $ :alt-tiles alt-tiles)
      (tset $ :main-tiles main-tiles)
      (each [_ {: id : x : y : fields} (ipairs entities.entities)]
        (case id
          :Player_start
          (let [player (player-ent.new! x y on-treasure)] (player:add) (tset $ :player player))
          :School (-> (school-ent.new! x y (?. fields :speed)) (: :add))
          :Shark (-> (shark.new! x y (?. fields :speed)) (: :add))
          :Treasure (-> (treasure.new! x y (?. fields :type)) (: :add))
          ))
      (bg:setTilemap layer.tilemap)
      (layer.tilemap:setImageTable $.main-tiles)
      
      (tset $ :curr-tiles $.main-tiles)
      (tset $ :far-bg far-bg)
      (tset $ :far-bg2 far-bg2)
      (far-bg:moveTo 0 0)
      (far-bg:setZIndex -101)
      (far-bg2:moveTo 110 110)
      (far-bg2:setZIndex -102)
      (far-bg:setIgnoresDrawOffset true)
      (far-bg2:setIgnoresDrawOffset true)
      (far-bg:add)
      (far-bg2:add)
      (bg:setCenter 0 0)
      (bg:moveTo 0 0)
      (bg:setZIndex -100)
      ;; (player:add)
      (bg:add)
      (: (player-hud.new! $.player) :add)
      ;; (printTable (ldtk.load-level {:level 0}))
      )
    )

  (fn exit! [$]
    (tset $ :player nil)
    (gfx.setDrawOffset 0 0)
    )

  (fn tick! [$scene]
    (gfx.sprite.performOnAllSprites
     (fn react-each [ent]
       (if (?. ent :react!) (ent:react! $scene))))

    ;; Handle animated BG via image table swaps
    (tset $scene :ticks (+ $scene.ticks 1))
    ($scene.far-bg:moveBy (* 0.25 (math.cos (// $scene.ticks 30))) (* 0.25 (math.sin (// $scene.ticks 30))))
    ($scene.far-bg2:moveBy (* -0.25 (math.cos (// $scene.ticks 30))) 0)
    (if (and (= (% (// $scene.ticks 12) 2) 0) (= $scene.curr-tiles $scene.alt-tiles))
        (do ($scene.tilemap:setImageTable $scene.main-tiles) (tset $scene :curr-tiles $scene.main-tiles) ($scene.bg:markDirty))
        (and (not= (% (// $scene.ticks 12) 2) 0) (= $scene.curr-tiles $scene.main-tiles))
        (do ($scene.tilemap:setImageTable $scene.alt-tiles) (tset $scene :curr-tiles $scene.alt-tiles) ($scene.bg:markDirty)))

    (if $scene.player
        (let [player-x $scene.player.x
              player-y $scene.player.y
              player-health $scene.player.state.health
              player-invuln (or $scene.player.state.invuln-ticks 0)
              center-x (clamp 0 (- player-x 200) (- $scene.width 400))
              center-y (clamp 0 (- player-y 120) (- $scene.height 240))]
          (gfx.setDrawOffset (- 0 center-x) (- 0 center-y))
          (each [_ other (ipairs ($scene.player:overlappingSprites))]
            (if (and (not other.wall?) (<= player-invuln 0))
                ($scene.player:take-damage)))
          ;; (if (and (> (length ) 0)
          ;;          (<= player-invuln 0))
          ;;     ($scene.player:take-damage))
          (if ($scene.player:dead?)
              (scene-manager:select! :menu))))
    )

  (fn draw! [$]
    ;; ($.layer.tilemap:draw 0 0)
    )
  )

