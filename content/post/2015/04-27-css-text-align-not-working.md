---
title: "CSS text-align center not working?"
date: "2015-04-27"
tags:
    - code
---

Well, the `text-align:center` will not work if you are trying to
center a **block** element.

w3c says:

> The text-align property describes how inline-level content of a block container is aligned.

So, when you want to align center an element like button or div, make sure the
element is an inline element, otherwise it will 'not working'.

Demo:

<a class="jsbin-embed" href="http://jsbin.com/duwayagina/1/embed?html,css,output">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
