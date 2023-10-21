(import-macros {: inspect : defns} :source.lib.macros)

(defns :player
  [pressed? playdate.buttonIsPressed
   gfx playdate.graphics
   scene-manager (require :source.lib.scene-manager)
   anim (require :source.lib.animation)]

  (fn react! [{: state : height : x : y : width &as self} $scene]
    (let [dy (if (pressed? playdate.kButtonUp) (* -1 state.speed)
                 (pressed? playdate.kButtonDown) (* 1 state.speed)
                 0)
          dx (if (pressed? playdate.kButtonLeft) (* -1 state.speed)
                 (pressed? playdate.kButtonRight) (* 1 state.speed)
                 0)
          dx (if (and (>= (+ x width) $scene.width) (> dx 0)) 0
                 (and (<= x 0) (< dx 0)) 0
                 dx)
          dy (if (and (>= (+ y height) $scene.height) (> dy 0)) 0
                 (and (<= y 0) (< dy 0)) 0
                 dy)]
      (tset self :state :dx dx)
      (tset self :state :dy dy)
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

