"use strict"
gulp = require("gulp")
browserSync = require("browser-sync")
settings =
  url: "wordpress.local"
  theme: "./www/wordpress/wp-content/themes/twentyfourteen/**"

gulp.task "init", ->
  browserSync.init null,
    proxy: settings.url
    notify: false


gulp.task "reload", ->
  browserSync.reload()


gulp.task "watch", ->
  gulp.watch [settings.theme], ["reload"]


gulp.task "default", [
  "init"
  "reload"
  "watch"
]