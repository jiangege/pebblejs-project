require! {
  gulp
  "gulp-livescript": liveScript
  "gulp-sass": sass
  "gulp-clean": clean
  "gulp-watch": watch
  "gulp-sourcemaps": sourcemaps
  "gulp-nodemon":nodemon
  "gulp-develop-server": server
}

gulp.task \clean, ->
  gulp.src "#{__dirname}/src/js/component/**/*" read: false
    .pipe clean!

gulp.task \transfer, ["clean"] ->
  gulp.src "#{__dirname}/js-src/**/!(*.ls)"
    .pipe gulp.dest "#{__dirname}/src/js/"

gulp.task \ls-compile, ["transfer"], ->
  gulp.src "#{__dirname}/js-src/**/*.ls"
    .pipe liveScript bare: true
    .pipe gulp.dest "#{__dirname}/src/js/"


gulp.task \web-clean, ->
  gulp.src "#{__dirname}/webserv/dist/**/*" read: false
    .pipe clean!

gulp.task \web-transfer, ["web-clean"], ->
  gulp.src "#{__dirname}/webserv/public/**/!(*.ls|*.scss)" base: "#{__dirname}/webserv/public/"
    .pipe gulp.dest "#{__dirname}/webserv/dist/"

gulp.task \web-ls-watch-compile, ->
  gulp.src "#{__dirname}/webserv/public/**/*.ls" base: "#{__dirname}/webserv/public/"
    .pipe watch "#{__dirname}/webserv/public/**/*.ls"
    .pipe sourcemaps.init!
    .pipe liveScript bare: true
    .pipe sourcemaps.write "./"
    .pipe gulp.dest "#{__dirname}/webserv/dist/"

gulp.task \web-sass-compile,  ->
  gulp.src "#{__dirname}/webserv/public/**/*.scss" base: "#{__dirname}/webserv/public/"
    .pipe sass!.on('error', sass.logError)
    .pipe sourcemaps.write "./"
    .pipe gulp.dest "#{__dirname}/webserv/dist/"

gulp.task \web-sass-watch, ["web-sass-compile"] ->
  watch "#{__dirname}/webserv/public/**/*.scss", ->
    gulp.src "#{__dirname}/webserv/public/**/*.scss" base: "#{__dirname}/webserv/public/"
      .pipe sass!.on('error', sass.logError)
      .pipe sourcemaps.write "./"
      .pipe gulp.dest "#{__dirname}/webserv/dist/"


gulp.task \run:webserv, -> server.listen path:  "#{__dirname}/webserv/app.js"

gulp.task \web, ["run:webserv", "web-transfer", "web-ls-watch-compile", "web-sass-watch"], ->
