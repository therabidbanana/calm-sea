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
      ]
  (scene-manager:load-scenes! (require :source.game.scenes))
  (scene-manager:select! :title)

  (fn playdate.update []
    (if ($ui:active?)
        (do
          ($ui:tick!) ($ui:render!))
        (do
          (scene-manager:tick!)
          (scene-manager:draw!)))))

