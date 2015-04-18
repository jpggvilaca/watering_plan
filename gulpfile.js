// Var declarations

var gulp = require('gulp'),
	uglify = require('gulp-uglify'),
	sass = require('gulp-sass');

//// Gulp tasks ////

// Uglifies

gulp.task('scripts', function() {
	gulp.src('client/*.js')
	.pipe(uglify())
	.pipe(gulp.dest('build/js'));
});

// Styles

gulp.task('styles', function() {
	gulp.src('client/sass/*.scss')
	.pipe(sass())
	.pipe(gulp.dest('build/styles/'))
});

// Watch Task

gulp.task('watch', function(){
	gulp.watch('client/*.js', ['scripts']);
});

gulp.task('default', ['scripts', 'styles', 'watch']);