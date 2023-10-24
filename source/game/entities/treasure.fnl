(import-macros {: inspect : defns} :source.lib.macros)

(defns :treasure
  [gfx playdate.graphics
   anim (require :source.lib.animation)]

  (fn react! [{: state : height : x : y : width &as self} $scene]
    ;; Give player treasure
    (let [player (?. (self:overlappingSprites) 1)]
      (if player
          (player:give-treasure! state._type)))
    self)

  (fn update [{:state {: animation} : x : y &as self}]
    (self:setImage (animation:getImage)))

  (fn new! [x y _type]
    (let [image (gfx.imagetable.new (.. :assets/images/ _type))
          animation (anim.new {: image :states [{:state :sitting :start 1 :end 1}]})
          treasure (gfx.sprite.new)]
      (treasure:setBounds x y 16 16)
      (treasure:setCenter 0 0)
      (tset treasure :update update)
      (tset treasure :react! react!)
      (tset treasure :state {: animation : _type :visible true})
      (treasure:setCollideRect 0 0 16 16)
      (treasure:setGroups [2])
      (treasure:setCollidesWithGroups [1])
      treasure)))
