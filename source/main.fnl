;; Patch for missing require
(global package {:loaded {} :preload {}})
(fn _G.require [name]
  (if (not (. package.loaded name))
      (tset package.loaded name ((?. package.preload name))))
  (?. package.loaded name))
;; End patch for missing require

(import-macros {: inspect : pd/import} :source.lib.macros)

(pd/import :CoreLibs/object)
(pd/import :CoreLibs/graphics)
(pd/import :CoreLibs/sprites)
(pd/import :CoreLibs/timer)

(global $config {:debug true})

(let [{: scene-manager} (require :source.lib.core)
      $ui (require :source.lib.ui)
      timer playdate.timer
      ]
  (scene-manager:load-scenes! (require :source.game.scenes))
  (scene-manager:select! :logo)

  (fn playdate.update []
    (if ($ui:active?)
        (do
          (timer.updateTimers)
          ($ui:tick!)
          ($ui:render!)
          (scene-manager:transition-draw!)
          )
        (do
          (timer.updateTimers)
          (scene-manager:tick!)
          (scene-manager:draw!)
          (scene-manager:transition-draw!)))))

