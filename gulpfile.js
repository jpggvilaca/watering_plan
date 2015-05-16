// Var declarations

var gulp = require('gulp'),
	uglify = require('gulp-uglify'),
	sass = require('gulp-sass'),
	plumber = require('gulp-plumber'),
	webserver = require('gulp-webserver'),
	minifyHTML = require('gulp-minify-html'),
	gulpRiot = require('gulp-riot'),
	riot = require('riot');

//// Gulp tasks ////

// Uglifies (minifies js)

gulp.task('scripts', function() {
	gulp.src('client/scripts/*.js')
		.pipe(uglify())
		.pipe(plumber())
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
 
  return gulp.src('index.html')
    .pipe(minifyHTML(opts))
    .pipe(gulp.dest('build/'));
});

// Mounts riot tags

gulp.task('riot-gulp', function() {
	return gulp.src('client/tags/*.tag')
	.pipe(gulpRiot())
	.pipe(gulp.dest('build/js'));
});

// Watch Task (watch changes on all files)

gulp.task('watch', function(){
	gulp.watch('client/scripts/*.js', ['scripts']);
	gulp.watch('client/sass/*.scss', ['styles']);
	gulp.watch('index.html', ['minify-html']);
	gulp.watch('client/tags/*.tag', ['riot-gulp']);
});

// Starts the server

gulp.task('webserver', function() {
  gulp.src('./')
    .pipe(webserver({
      livereload: false,
      directoryListing: false,
      open: true,
      port: 3000
    }));
});

// Main task (which runs everything)

gulp.task('default', ['scripts', 'styles', 'minify-html' ,'webserver', 'riot-gulp']); 