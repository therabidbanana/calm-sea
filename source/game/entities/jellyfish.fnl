(import-macros {: inspect : defns} :source.lib.macros)

(defns :jellyfish
  [gfx playdate.graphics
   anim (require :source.lib.animation)]

  (fn react! [{: state : height : x : y : width &as self} $scene]
    (if (and (< $scene.state.stage-width x) (> state.speed 0))
        (tset state :speed (- 0 state.speed))
        (and (> -32 x) (< state.speed 0))
        (tset state :speed (- 0 state.speed)))
    self)

  (fn update [{:state {: animation : location-anim} : x : y &as self}]
    (self:setImage (animation:getImage))
    ;; (self:markDirty)
    (self:moveTo (location-anim:currentValue)))

  (fn new! [x y {:fields {: speed : range} : tile-h : tile-w }]
    (let [image (gfx.imagetable.new :assets/images/jellyfish)
          animation (anim.new {: image :delay 350
                               :states [{:state :up :start 1 :end 3}]})
          school (gfx.sprite.new)
          home-point (playdate.geometry.point.new x y)
          range-point (playdate.geometry.point.new (* range.cx tile-w) (* range.cy tile-h))
          location-anim (playdate.graphics.animator.new (/ 10000 speed) home-point range-point)
          ]
      (set location-anim.repeatCount -1)
      (set location-anim.reverses true)
      (school:setBounds x y 24 32)
      (school:setCenter 0 0)
      (tset school :update update)
      (tset school :react! react!)
      (tset school :collisionResponse #gfx.sprite.kCollisionTypeOverlap)
      (tset school :state {: animation
                           : home-point
                           : range-point
                           : location-anim
                           :visible true})
      (school:setCollideRect 2 9 21 23)
      (school:setGroups [3])
      school)))
