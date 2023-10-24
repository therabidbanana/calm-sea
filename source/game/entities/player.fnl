(import-macros {: inspect : defns : clamp} :source.lib.macros)

(defns :player
  [pressed? playdate.buttonIsPressed
   gfx playdate.graphics
   $ui (require :source.lib.ui)
   anim (require :source.lib.animation)]

  (fn react! [{: state : height : x : y : width &as self} $scene]
    (let [accel (if (or (pressed? playdate.kButtonDown) (pressed? playdate.kButtonA))
                    0.25
                    -0.01)
          
          drag  (if (pressed? playdate.kButtonUp)
                    0.2
                    0.92)
          speed (clamp 0 (+ (* drag state.speed) accel) 4)
          
          angle   (playdate.getCrankPosition)
          (dx dy) (-> speed
                      (playdate.geometry.vector2D.newPolar angle)
                      (: :unpack))

          dx (if (and (>= (+ x width) $scene.width) (> dx 0)) 0
                 (and (<= x 0) (< dx 0)) 0
                 dx)
          dy (if (and (>= (+ y height) $scene.height) (> dy 0)) 0
                 (and (<= y 0) (< dy 0)) 0
                 dy)]
      (tset self :state :dx dx)
      (tset self :state :dy dy)
      (tset self :state :angle angle)
      (tset self :state :invuln-ticks (math.max 0 (- (or state.invuln-ticks 0) 1)))
      (tset self :state :speed speed)
      (tset self :state :swimming? (not (and (= 0 (math.floor dx)) (= 0 (math.floor dy)))))
      )
    self)

  (fn update [{:state {: animation : invuln-ticks : dx : dy : angle : swimming?} &as self}]
    (if swimming?
        (animation:transition! (.. :swim- (math.floor (+ 0.5 (/ (or angle 0) 45)))))
        (animation:transition! :standing))
    (self:setVisible (= (% (// (or invuln-ticks 0) 5) 2) 0))
    (self:setImage (animation:getImage))
    (self:moveBy (math.floor dx) (math.floor dy))
    )

  (fn take-damage [{:state {: health : invuln-ticks &as state}}]
    (if (<= (or invuln-ticks 0) 0)
        (doto state
          (tset :invuln-ticks 80)
          (tset :health (- health 1)))
        ))

  (fn dead? [{:state {: health}}]
    (<= health 0))

  (fn give-treasure! [self treasure-type]
    ($ui:open-textbox! {:text (gfx.getLocalizedText "mermaid.foundtreasure")
                        :action #(self.state.on-treasure treasure-type)}))

  (fn new! [x y on-treasure]
    (let [image (gfx.imagetable.new :assets/images/mermaid)
          animation (anim.new {: image :states [{:state :standing :start 1 :end 8}
                                                ;; In 45 degree increments
                                                {:state :swim-0 :start 9 :end 11}
                                                {:state :swim-1 :start 12 :end 14}
                                                {:state :swim-2 :start 15 :end 17}
                                                {:state :swim-3 :start 18 :end 20}
                                                {:state :swim-4 :start 21 :end 23}
                                                {:state :swim-5 :start 24 :end 26}
                                                {:state :swim-6 :start 27 :end 29}
                                                {:state :swim-7 :start 30 :end 32}
                                                {:state :swim-8 :start 9 :end 11}
                                                ]})
          player (gfx.sprite.new)]
      (player:setBounds x y 32 32)
      (player:setCenter 0 0)
      (tset player :update update)
      (tset player :react! react!)
      (tset player :take-damage take-damage)
      (tset player :give-treasure! give-treasure!)
      (tset player :dead? dead?)
      (tset player :state {: animation : on-treasure :health 3 :angle 0 :speed 0 :dx 0 :dy 0 :visible true})
      (player:setCollideRect 6 1 24 30)
      (player:setGroups [1])
      (player:setCollidesWithGroups [3])
      player)))

