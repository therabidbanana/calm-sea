(import-macros {: inspect : defns : clamp} :source.lib.macros)

(defns :player-hud
  [gfx playdate.graphics
   anim (require :source.lib.animation)]

  (fn react! [{: state : height : x : y : width &as self} $scene]
    (let [(img _) (gfx.imageWithText (.. "Player Health: " state.health)
                                     200 100) 
          ]
      (self:setImage img))
    self)

  (fn update [{:state {: animation : dx : dy : walking?} &as self}]
    )

  (fn new! [player-ent]
    (let [
          ;; image (gfx.imagetable.new :assets/images/mermaid)
          ;; animation (anim.new {: image :states [{:state :standing :start 1 :end 1 :delay 2300}]})
          hud (gfx.sprite.new)
          (img _) (gfx.imageWithText (.. "Player Health: " player-ent.state.health)
                                     200 100) 
          ]
      (hud:setCenter 0 0)
      (hud:moveTo 2 2)
      (hud:setImage img)
      (tset hud :update update)
      (tset hud :react! react!)
      (tset hud :state player-ent.state)
      (hud:setIgnoresDrawOffset true)
      hud)))
