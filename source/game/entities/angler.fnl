(import-macros {: inspect : defns} :source.lib.macros)

(defns :angler
  [gfx playdate.graphics
   anim (require :source.lib.animation)]

  (fn react! [{: state : height : x : y : width &as self} $scene]
    (if (and (< $scene.state.stage-width x) (> state.speed 0))
        (tset state :speed (- 0 state.speed))
        (and (> -32 x) (< state.speed 0))
        (tset state :speed (- 0 state.speed)))
    (tset state :ticks (+ state.ticks 1))
    self)

  (fn update [{:state {: animation : speed : ticks} : x : y &as self}]
    (if (> speed 0)
        (animation:transition! :right)
        (animation:transition! :left))
    (self:setImage (animation:getImage))
    ;; (self:markDirty)
    (self:moveBy speed (math.sin (// ticks 40))))

  (fn new! [x y speed]
    (let [image (gfx.imagetable.new :assets/images/angler)
          animation (anim.new {: image :delay 500
                               :states [{:state :right :start 1 :end 3}
                                        {:state :left :start 4 :end 6}
                                        ]})
          school (gfx.sprite.new)]
      (school:setBounds x y 42 32)
      (school:setCenter 0 0)
      (tset school :update update)
      (tset school :react! react!)
      (tset school :collisionResponse #gfx.sprite.kCollisionTypeOverlap)
      (tset school :state {:ticks 0 : animation :speed (or speed 3) :dx 0 :dy 0 :visible true})
      (school:setCollideRect 2 8 34 15)
      (school:setGroups [3])
      school)))
