const gulp = require('gulp');
const babel = require('gulp-babel');
const uglify = require('gulp-uglify');
const sass = require('gulp-sass');
const autoprefixer = require('gulp-autoprefixer');
const cleanCSS = require('gulp-clean-css');
const webserver = require('gulp-webserver');
const plumber = require('gulp-plumber');

gulp.task('sass', function () {
  return gulp.src('./src/combobox.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(autoprefixer())
    .pipe(cleanCSS())
    .pipe(gulp.dest('./dist'));
});

gulp.task('js', () => {
  return gulp.src('src/combobox.js')
    .pipe(plumber())
    .pipe(babel({
      presets: ['es2015']
    }))
    .pipe(uglify())
    .pipe(gulp.dest('dist'));
});

gulp.task('watch', function () {
  gulp.watch('./src/*.js', ['js']);
  gulp.watch('./src/*.scss', ['sass']);
});

gulp.task('serve', function() {
  gulp.src('./')
    .pipe(webserver({
      livereload: true,
      directoryListing: true,
      open: '/example.html'
    }));
});

gulp.task('default', ['watch', 'serve']);
