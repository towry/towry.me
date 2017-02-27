---
tags:
    - normal
title: "An idea for multiple page app development"
date: "2016-11-23"
---

We have a project that use `tornado` for backend development, and for front-end, we use Webpack + Vue.js, it is a multiple page app.

I use `html-webpack-plugin` and `html-loader` to process the `tornado` templates, so here is an issue, every time I want to develop some page, I have to change the webpack config, specific the template file name in the webpack config.

Here is the idea that I come up lately to solve the problem.

The `html-webpack-plugin` has a `lazy` option, that makes the dev server running webpack at every request, this is important. So, at every request, we check the request url, if the request url is equal to a template name, we apply a `html-webpack-plugin` with the template file name to the single webpack compiler, and make the `webpack-dev-middleware` instance recompile the bundle.

Because when we view more pages, the `html-webpack-plugin` instance will become more, and it will slow down the whole build. The solution is that after every seconds we check if the page is still opened, if it's closed, we remove that `html-webpack-plugin` instance. And how could we know if a page is closed? use websocket!

#### Reference

* [https://github.com/webpack/webpack-dev-middleware#user-content-advanced-api](https://github.com/webpack/webpack-dev-middleware#user-content-advanced-api)
