// Var declarations

var gulp = require('gulp'),
	uglify = require('gulp-uglify'),
	sass = require('gulp-sass'),
	plumber = require('gulp-plumber'),
	connect = require('gulp-connect'),
	minifyHTML = require('gulp-minify-html');

//// Gulp tasks ////

// Uglifies (minifies js)

gulp.task('scripts', function() {
	gulp.src('client/*.js')
		.pipe(plumber())
		.pipe(uglify())
		.pipe(gulp.dest('build/js'));
});

// Styles (minifies sass)

gulp.task('styles', function() {
	gulp.src('client/sass/*.scss')
		.pipe(sass({
			outputStyle: 'compressed',
			errLogToConsole: true
		}))
		.pipe(gulp.dest('build/styles/'))
});

// HTML minifier

gulp.task('minify-html', function() {
  var opts = {
    conditionals: true,
    spare:true
  };
 
  return gulp.src('public/*.html')
    .pipe(minifyHTML(opts))
    .pipe(gulp.dest('build/'));
});

// Watch Task (watch changes on all files)

gulp.task('watch', function(){
	gulp.watch('client/*.js', ['scripts']);
	gulp.watch('client/sass/*.scss', ['styles']);
});

// Starts the server

gulp.task('connect', function() {
  connect.server({
    root: 'build/',
    port: 3000,
    livereload: true
  });
});

// Main task (which runs everything)

gulp.task('default', ['scripts', 'styles', 'watch', 'minify-html' ,'connect']); 