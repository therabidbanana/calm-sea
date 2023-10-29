(import-macros {: inspect : defns} :source.lib.macros)

(defns :treasure
  [gfx playdate.graphics
   anim (require :source.lib.animation)]

  (fn react! [{: state : height : x : y : width &as self} $scene]
    ;; Give player treasure
    (let [player (?. (self:overlappingSprites) 1)]
      (if player
          (player:give-treasure! state._type)))
    (tset state :ticks (+ state.ticks 1))
    (if self.bubbled?
        (self:moveBy (* 0.3 (math.cos (// state.ticks 40)))
                     (* 0.25 (math.sin (// state.ticks 40)))))
    self)

  (fn update [{:state {: animation} : x : y &as self}]
    (if self.bubbled?
        nil
        (self:setImage (animation:getImage)))
    )

  (fn draw [{:state {: animation}  &as self} x y w h]
    (if self.bubbled?
        (do
          (gfx.setLineWidth 1)
          (gfx.setColor gfx.kColorBlack)
          (gfx.drawCircleInRect x y w h)
          (let [img (animation:getImage)]
            (img:drawCentered (+ x 16) (+ 16 y))))))

  (fn new! [x y _type bubbled?]
    (let [image (gfx.imagetable.new (.. :assets/images/ _type))
          animation (anim.new {: image :states [{:state :sitting :start 1 :end 6}]})
          treasure (gfx.sprite.new)]
      (if bubbled?
          (treasure:setBounds x y 32 32)
          (treasure:setBounds x y 16 16))
      (if bubbled?
          (treasure:setIgnoresDrawOffset true))
      (treasure:setCenter 0 0)
      (tset treasure :bubbled? bubbled?)
      (tset treasure :update update)
      (tset treasure :draw draw)
      (tset treasure :react! react!)
      (tset treasure :state {:ticks 0 : animation : _type :visible true})
      (treasure:setCollideRect 0 0 16 16)
      (treasure:setGroups [2])
      (treasure:setCollidesWithGroups [1])
      treasure)))
