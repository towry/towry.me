---
title: "The simple gulp plugin that mapping files to another folder"
date: "2015-04-08"
tags:
    - code
---

I know gulp.dest already did the job and that is it’s role, but gulp.dest just append the file(vinyl)’s relative path to the dest directory, so there are some cases gulp.dest will did in the way that against our expectation.

This simple gulp plugin is to rectify that fault, because it’s simple, so you can just put it in your gulpfile. My case is, I was playing around with nw.js, the folder structure is

```
root - node_modules/
     - build/
     - src/--
            | - index.html, etc
     - package.json
```

I want `package.json` and all files in `src/` to be available in build directory in the same structure every time I edited a file. The files is watched by gulp.watch then pipe into another stream, in which we will modify the file’s path so it can be output in build directory correctly. The code is

```javascript
gulp.task('watchify', function () {
    return gulp.src(filesToWatch)
        .pipe(function () {
            // Here is the simple plugin
            var stream = new Stream.Transform({objectMode: true});
            stream._transform = function (file, enc, cb) {
                if (path.basename(file.relative) == 'package.json') {
                    cb(null, file);
                    return;
                } else {
                    // prefix src before file.relative
                    file.path = path.join(file.base, 'src', file.relative);
                }

                cb(null, file);
            }

            return stream;
        }.call(this))
        .pipe(gulp.dest('build/'));
})
```

The eventual folder struct in build directory is

```
root - node_modules/
     - build/--
              | - src/-- index.html etc
              | - package.json
     - src/--
            | - index.html, etc
     - package.json
```

Without that plugin, the outcome directory structure will be

```
root - node_modules/
     - build/--
              | - package.json
              | - index.html etc
     - src/--
            | - index.html, etc
     - package.json
```
