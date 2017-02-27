---
title: "Style the file input"
date: "2015-08-27"
tags:
    - code
---

```html
<input type="file" class="file-btn" />
```

Input control can not be styled in css, it is not like
div, you can hide this and color that. If you hide the input, then it
will become useless, we need the control clickable and open a file browser.

The correct way to style the file input control is we hide it, but make
the area still clickable.

Here are three ways to achieve that.

## webkit browser

In webkit like browser, you can use `-webkit-file-upload-button`
pseudo element selector to make the button disappear, then use `
color: transparent` to make the text invisible. After that, there
still have an area that is clickable.

The css:

```css
.file-btn::-webkit-file-upload-button {
  visibility: hidden;
}
.file-btn {
  color: transparent;
}
```

## Use opacity=0

The second way is to use opacity=0 to make the control invisible
but still clickable. and you put a fake button on top of it.

The html:

```html
<div class="fake-btn">
  <input type="file" class="file-btn">
</div>
```

The css:

```css
.fake-btn {
  position: relative;
  width: 50px;
  height: 50px;
  color: #fff;
  background: #000;
}
.fake-btn .file-btn {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  opacity: 0;
  filter: alpha(opacity=0)
}
```

## Use font-size

This is the third way, I think it's a better way if you care about
old browser users.

You can use font-size to make the file input control very big and limit
the size of fake control.

The html is same as the previous.

The css:

```css
.fake-btn {
  position: relative;
  width: 50px;
  height: 30px;
  overflow: hidden; // important
}
.file-btn {
  font-size: 9999px !important; // make this big enough to let the button out of screen;
  position: absolute;
  opacity: 0; // still useful
  width: 50px;
  height: 30px;
}
```

The [result](http://jsbin.com/juceke/2/edit?html,css,output):

<a class="jsbin-embed" href="http://jsbin.com/juceke/2/embed">JS Bin on jsbin.com</a><script src="http://static.jsbin.com/js/embed.min.js?3.34.2"></script>
