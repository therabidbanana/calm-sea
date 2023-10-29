(import-macros {: inspect : defns} :source.lib.macros)

(defns :shark
  [gfx playdate.graphics
   anim (require :source.lib.animation)]

  (fn react! [{: state : height : x : y : width &as self} $scene]
    (let [distant-x (if (> state.speed 0)
                        $scene.state.stage-width
                        0)
          sprites-in-sight (icollect [_ p (ipairs (gfx.sprite.querySpritesAlongLine x y distant-x y))]
                             (if p.player? p))
          speed-boost (if (> (length sprites-in-sight) 0) ;;counting self?
                          2 1)
          ]
      (tset state :speed-boost speed-boost)
      (if (and (< $scene.state.stage-width x) (> state.speed 0))
          (tset state :speed (- 0 state.speed))
          (and (> -32 x) (< state.speed 0))
          (tset state :speed (- 0 state.speed)))
      )
    self)

  (fn update [{:state {: animation : speed-boost : speed} : x : y &as self}]
    (if (> speed 0)
        (animation:transition! :right)
        (animation:transition! :left))
    (self:setImage (animation:getImage))
    ;; (self:markDirty)
    (self:moveBy (* speed-boost speed) 0))

  (fn new! [x y {:fields {: speed : range} : tile-x : tile-y}]
    (let [image (gfx.imagetable.new :assets/images/shark)
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
      (tset school :state {: animation :speed (or speed 3) :dx 0 :dy 0 :visible true})
      (school:setCollideRect 2 8 34 15)
      (school:setGroups [3])
      school)))
