(import-macros {: inspect : defns} :source.lib.macros)

(defns :horizontal-current
  [gfx playdate.graphics
   anim (require :source.lib.animation)]

  (fn draw [{: state : x : y : width : height &as self} dx dy w h]
    ;; (gfx.pushContext)
    (gfx.pushContext)
    (gfx.setDrawOffset 0 0)
    ;; (gfx.setColor gfx.kColorBlack)
    (gfx.setPattern state.image (- 24 (% (// state.ticks 6) 24)) (% dy 2))
    (gfx.fillRect (+ x dx) (+ y dy) width height)
    (gfx.popContext)
    )

  (fn react! [{: state : height : x : y : width &as self} $scene]
    (each [_ player (ipairs (self:overlappingSprites))]
      (player:moveBy state.speed 0))
    (tset state :ticks (+ state.ticks 1))
    (self:markDirty)
    self)

  (fn new! [x y {: width : height : speed}]
    (let [image (gfx.image.new :assets/images/horizontal-current-pattern)
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
