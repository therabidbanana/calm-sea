(import-macros {: pd/import : defns : inspect : clamp} :source.lib.macros)

(defns :level-builder [base-level (require :source.lib.level)
                       entities (require :source.game.entities.core)
                       scene-manager (require :source.lib.scene-manager)
                       gfx playdate.graphics]

  (fn add-entities! [{: tile-h : tile-w &as layer}]
    (var player-ent nil)
    (each [_ {: id : x : y : fields} (ipairs layer.entities)]
      (case id
        :Player_start
        ;; TODO fix on-treasure
        (let [player (entities.player.new! x y on-treasure)] (player:add) (set player-ent player))

        :School (-> (entities.school.new! x y (?. fields :speed)) (: :add))

        :Shark (-> (entities.shark.new! x y (?. fields :speed)) (: :add))

        :Angler (-> (entities.angler.new! x y (?. fields :speed)) (: :add))

        :Jellyfish (-> (entities.jellyfish.new! x y {: fields : tile-w : tile-h})
                       (: :add))

        :Treasure (-> (entities.treasure.new! x y (?. fields :type)) (: :add))

        ))
    player-ent)

  (fn tile-layer-sprite [layer solid?]
    (let [bg (gfx.sprite.new)
          walls (if solid?
                    (gfx.sprite.addWallSprites layer.tilemap)
                    [])]
      ;; Assumes all walls are slide + group 4
      (each [_ sprite (ipairs walls)]
        (tset sprite :wall? true)
        (tset sprite :collisionResponse #gfx.sprite.kCollisionTypeSlide)
        (sprite:setGroups [4])
        ;; (sprite:setCollidesWithGroups [1])
        )
      (bg:setTilemap layer.tilemap)
      (bg:setCenter 0 0)
      (bg:moveTo 0 0)
      (bg:setZIndex (if solid? -90 -100))
      (bg:add)
      {:tilemap layer.tilemap
       :sprite  bg})
    )

  (fn prepare-level! [level-data]
    (let [loaded (base-level.prepare-level level-data)
          tile-layers (collect [_ {: layer-id &as l} (ipairs (?. loaded :tile-layers))]
                        (values layer-id l))
          tiles (tile-layer-sprite (. tile-layers :Tiles))
          wall-layer (tile-layer-sprite (. tile-layers :Walls) true)
          entities (?. loaded :entity-layers 1)
          player (add-entities! entities)]
      {
       :stage-width loaded.w :stage-height loaded.h
       :ticks 0
       : tiles
       : walls
       : player
       }))

  (fn tick-level! [{: state &as $scene}]
    (tset state :ticks (+ state.ticks 1))
    (gfx.sprite.performOnAllSprites
     (fn react-each [ent]
       (if (?. ent :react!) (ent:react! $scene)))
     (if state.player
         (let [player-x state.player.x
               player-y state.player.y
               player-health state.player.state.health
               player-invuln (or state.player.state.invuln-ticks 0)
               center-x (clamp 0 (- player-x 200) (- state.stage-width 400))
               center-y (clamp 0 (- player-y 120) (- state.stage-height 240))]
           (gfx.setDrawOffset (- 0 center-x) (- 0 center-y))
           (each [_ other (ipairs (state.player:overlappingSprites))]
             (if (and (not other.wall?) (<= player-invuln 0))
                 (state.player:take-damage)))
           ;; (if (and (> (length ) 0)
           ;;          (<= player-invuln 0))
           ;;     ($scene.player:take-damage))
           (if (state.player:dead?)
               (scene-manager:select! :menu))))
     )

    )

  )
