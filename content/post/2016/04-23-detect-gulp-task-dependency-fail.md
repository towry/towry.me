---
title: "Detect gulp task dependency fail"
date: "2016-04-23"
tags:
    - code
---

There are some circumstances to detect gulp dependency task fail
without exit the process. For example you want to build javascripts
only after the `lint` task running successful, if the `lint` task
failed, we can just ignore the error and not run the javascript build
task.

```
var gutil = require('gulp-util');

gulp.task('lint-scripts', function () {
    // if there is an error, just throw it.
    return gulp.src(...)
        .pipe(..)
        .on('error', function () {
            throw new gutil.PluginError("...", {});
        });
    // ...
})

gulp.task('build-scripts', function () {
    gulp.start('lint-scripts',function (err) {
        if (err) {
            return;
        }
        // else, just build the scripts
    })
})
```
