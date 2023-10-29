(import-macros {: inspect : defns} :source.lib.macros)

(defns :vertical-current
  [gfx playdate.graphics
   anim (require :source.lib.animation)]

  (fn draw [{: state : x : y : width : height &as self} dx dy w h]
    ;; (gfx.pushContext)
    (gfx.pushContext)
    (gfx.setDrawOffset 0 0)
    ;; (gfx.setColor gfx.kColorBlack)
    (gfx.setPattern state.image
                    (- 7 (% dx 8))
                    (if (> state.speed 0)
                                    (- 23 (% (// state.ticks (// 12 state.speed)) 24))
                                    (- 0 (- (% (// state.ticks (// 12 state.speed)) 24) 23))
                                    ))
    (gfx.fillRect (+ x dx) (+ y dy) width height)
    (gfx.popContext)
    )

  (fn react! [{: state : height : x : y : width &as self} $scene]
    (each [_ player (ipairs (self:overlappingSprites))]
      (player:moveBy 0 state.speed))
    (tset state :ticks (+ state.ticks 1))
    (self:markDirty)
    self)

  (fn new! [x y {: width : height : speed}]
    (let [image (gfx.image.new :assets/images/vertical-current-pattern)
          current (gfx.sprite.new)]
      (current:setCenter 0 0)
      (current:setBounds x y width height)
      (tset current :wall? true) ;;ish
      (tset current :draw draw)
      (tset current :react! react!)
      (tset current :collisionResponse #gfx.sprite.kCollisionTypeOverlap)
      (tset current :state {: image :ticks 0 :speed (or speed 2) :visible true})
      (current:setCollideRect 0 0 width height)
      (current:setGroups [5])
      (current:setCollidesWithGroups [1])
      current)))
