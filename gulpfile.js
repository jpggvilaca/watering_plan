// Gulp Dependencies
var gulp = require('gulp');
var rename = require('gulp-rename');

// Build Dependencies
var browserify = require('gulp-browserify');
var uglify = require('gulp-uglify');

// Style Dependencies
var sass = require('gulp-sass');
var prefix = require('gulp-autoprefixer');
var minifyCSS = require('gulp-minify-css');

// Development Dependencies
var jshint = require('gulp-jshint');

// Server
var connect = require('gulp-connect');

// Tasks

gulp.task('lint-client', function() {
  return gulp.src('./client/**/*.js')
    .pipe(jshint());
    .pipe(jshint.reporter('default'));
});
 
gulp.task('webserver', function() {
  connect.server();
});
 
gulp.task('default', ['webserver']);

gulp.task('webserver', function() {
  connect.server({
    livereload: true
  });
});

// Browserify

gulp.task('browserify-client', ['lint-client'], function() {
	return gulp.src('client/index.js')
	    .pipe(browserify({
	      insertGlobals: true
	    }));
	    .pipe(rename('watering-plan.js'));
	    .pipe(gulp.dest('build'));
	    .pipe(gulp.dest('public/scripts'));
});

gulp.task('watch', function() {
  gulp.watch('client/**/*.js', ['browserify-client']);
});

// PreProcessing

gulp.task('sass', function() {
	return gulp.src('client/sass/index.scss')
	    .pipe(sass());
	    .pipe(gulp.dest('build'));
	    .pipe(gulp.dest('public/stylesheets'));
});

gulp.task('minify', ['sass'], function() {
	return gulp.src('build/watering-plan.css')
	    .pipe(minifyCSS());
	    .pipe(rename('watering-plan.min.css'));
	    .pipe(gulp.dest('public/stylesheets'));
});

gulp.task('uglify', ['browserify-client'], function() {
	return gulp.src('build/watering-plan.js')
	    .pipe(uglify());
	    .pipe(rename('watering-plan.min.js'));
	    .pipe(gulp.dest('public/scripts'));
});

gulp.task('build', ['uglify', 'minify']);