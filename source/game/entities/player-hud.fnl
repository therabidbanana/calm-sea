(import-macros {: inspect : defns : clamp} :source.lib.macros)

(defns :player-hud
  [gfx playdate.graphics
   anim (require :source.lib.animation)]

  (fn react! [{: state : hud-animation &as self} $scene]
    (if (= state.health 2)
        (hud-animation:transition! :three-pop {:if :three})
        (= state.health 1)
        (hud-animation:transition! :two-pop {:if :two}))
    self)

  (fn update [{: hud-animation &as self}]
    (self:setImage (hud-animation:getImage)))

  (fn new! [player-ent]
    (let [
          image (gfx.imagetable.new :assets/images/hud)
          animation (anim.new {: image :delay 500 :states [
                                                           {:state :three :start 1 :end 6}
                                                           {:state :three-pop :start 7 :end 9 :transition-to :two :delay 200}
                                                           {:state :two :start 10 :end 15}
                                                           {:state :two-pop :start 16 :end 18 :transition-to :one :delay 200}
                                                           {:state :one :start 19 :end 24}
                                                           ]})
          hud (gfx.sprite.new)
          ]
      (hud:setCenter 0 0)
      (hud:moveTo 2 2)
      (tset hud :hud-animation animation)
      (tset hud :update update)
      (tset hud :react! react!)
      (tset hud :state player-ent.state)
      (hud:setIgnoresDrawOffset true)
      hud)))
