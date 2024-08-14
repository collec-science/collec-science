var gulp  = require( "gulp" ),
    babel = require( "gulp-babel" ),
    src   = "./src/**/*.js",
    dst   = "./dst";


gulp.task( "build", function(){
  return gulp.src( src )
    .pipe( babel() )
    .pipe( gulp.dest( dst ) );
});

gulp.task( "watch", function(){
  return gulp.watch( src, [ "build" ] )
});

gulp.task( "default", [ "build", "watch" ] );
