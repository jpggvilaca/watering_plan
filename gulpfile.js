// Var declarations

var gulp = require('gulp'),
	uglify = require('gulp-uglify'),
	sass = require('gulp-sass'),
	plumber = require('gulp-plumber');

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
		.pipe(plumber())
		.pipe(sass({
			outputStyle: 'compressed'
		}))
		.pipe(gulp.dest('build/styles/'))
});

// Watch Task (watch changes on all files)

gulp.task('watch', function(){
	gulp.watch('client/*.js', ['scripts']);
	gulp.watch('client/sass/*.scss', ['styles']);
});


// Main task (which runs everything)

gulp.task('default', ['scripts', 'styles', 'watch']); 