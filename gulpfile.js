// Var declarations

var gulp = require('gulp'),
	uglify = require('gulp-uglify');

// Gulp tasks

gulp.task('default', function() {
	gulp.src('client/*.js')
	.pipe(uglify())
	.pipe(gulp.dest('build/js'));
});