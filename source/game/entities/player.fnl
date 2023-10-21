(import-macros {: inspect : defns : clamp} :source.lib.macros)

(defns :player
  [pressed? playdate.buttonIsPressed
   gfx playdate.graphics
   scene-manager (require :source.lib.scene-manager)
   anim (require :source.lib.animation)]

  (fn react! [{: state : height : x : y : width &as self} $scene]
    (let [accel (if (or (pressed? playdate.kButtonDown) (pressed? playdate.kButtonA))
                    0.3
                    -0.1)
          speed (clamp 0 (+ state.speed accel) 3)
          
          (dx dy) (-> speed
                      (playdate.geometry.vector2D.newPolar (playdate.getCrankPosition))
                      (: :unpack))

          dx (if (and (>= (+ x width) $scene.width) (> dx 0)) 0
                 (and (<= x 0) (< dx 0)) 0
                 dx)
          dy (if (and (>= (+ y height) $scene.height) (> dy 0)) 0
                 (and (<= y 0) (< dy 0)) 0
                 dy)]
      (tset self :state :dx dx)
      (tset self :state :dy dy)
      (tset self :state :speed speed)
      (tset self :state :walking? (not (and (= 0 dx) (= 0 dy))))
      (if (playdate.buttonJustPressed playdate.kButtonB)
          (scene-manager:select! :menu))
      )
    self)

  (fn update [{:state {: animation : dx : dy : walking?} &as self}]
    ;; (if walking?
    ;;     (animation:transition! :walking)
    ;;     (animation:transition! :standing {:if :walking}))
    (self:setImage (animation:getImage))
    (self:moveBy dx dy)
    )

  (fn new! [x y]
    (let [image (gfx.imagetable.new :assets/images/mermaid)
          animation (anim.new {: image :states [{:state :standing :start 1 :end 1 :delay 2300}]})
          player (gfx.sprite.new)]
      (player:setBounds x y 32 32)
      (player:setCenter 0 0)
      (tset player :update update)
      (tset player :react! react!)
      (tset player :state {: animation :speed 2 :dx 0 :dy 0 :visible true})
      player)))

