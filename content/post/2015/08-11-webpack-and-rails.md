---
title: "Webpack and Rails"
date: "2015-08-11"
tags:
    - code
---

I wrote an example to show how to make Webpack work with Rails, the repo is here:
[webpackrails-example](https://github.com/towry/webpackrails-example)

The gem that I use in that example is [webpackrails](http://github.com/towry/webpackrails),
it is forked from [browserify-rails](http://github.com/browserify-rails/browserify-rails).

So, how to use Webpack in Rails?

### Create a package.json file.

You need a `package.json` file in your Rails root.

```bash
{
  name: "abc",
  "dependencies": {
    "webpack": "^1.11.0"
  }
}
````

Run `npm install` to install the dependencies.

### Create a webpack.config.js file.

You need a `webpack.config.js` file in your Rails root, this is optional if
you don't need any extra options for webpack.

### Last, add webpackrails gem.

In the last, put `gem 'webpackrails', '>= 1.0'` in you Gemfile, then run `bundle install`.

---

To use react in your project, you will need `react-rails` gem, for more
information, please check the example.
