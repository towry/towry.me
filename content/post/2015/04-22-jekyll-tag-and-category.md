---
title: "Jekyll, the tag and category"
date: "2015-04-22"
tags:
    - code
---

Jekyll is a static site generator, the url is directory like, that's mean
if you have a post like "hello world", and the url is "post/2015/04/23/hello-world",
then jekyll will generate a `index.html` file in "_site/post/2015/04/23/hello-world/"
directory.

Jekyll doesn't have the feature to generate a `index.html` file for each tag, and
since the Github doesn't allow jekyll plugins, so it's hard to make the tag and
category links work.

My solution is use Google to do the work. Suppose here is a tag named "javascript",
then we generate it as `tag-javascript`, so when we search in google with our site
url along with the tag, like "site:towry.me tag-javascript", google will list all
posts in `towry.me` site which has a tag named "tag-javascript". We can also hide
the "tag-" part by using the css, the code:

```html
.hide {
    position: absolute !important;
    left: -999px !important;
}

<span class='hide'>tag-</span>javascript
```

Demo: <a href="https://www.google.com/search?q=site:towry.me+tag-jekyll">search
"site:towry.me+tag-jekyll"</a>
