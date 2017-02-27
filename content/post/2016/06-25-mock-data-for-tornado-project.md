---
tags:
    - normal
title: "mock data for tornado project"
date: "2016-06-25"
---

### 前端开发在tornado项目中模拟假数据的方法

在tornado项目中, 模板一般使用的是tornado自带的模板。如果是使用其他类似handlebars的模板的话，
可能不会有这样的问题，因为handlebars模板是跨语言的。那么对于tornado自带的模板，前端在开发调试
的时候，如何提供假数据来轻松开发呢？下面是我自己搭建的一个tornado项目环境，专门用来渲染这些模板，
并通过js文件来提供假数据。

我的思路是这样的，当tornado渲染一个模板时，他需要的数据是一些`dict`的东西，而前端可能对这些python
后端的东西不太熟悉，而在原项目代码里写模拟数据又非常麻烦，因为原项目可能需要依赖很多其他的服务。
那么我就自己搭建一个简单的tornado项目，只用来渲染这些模板。而这些数据的提供，可以让前端写在对应的
js文件里面，通过execjs来执行这些js文件，获取这些js文件exports出来的数据，将这些数据转换为python
的数据格式，传给要渲染的模板。这样前端可以只关注这些js文件，而不用管python的东西。如果要更改数据，
只在js文件里更改某个对象的属性或属性值就可以了。

加入一个项目的模板结构是这样的：

```
templates -
	account -
		account-config.html
		account-preview.html
```

那么在我的模拟服务器里，会存放这对应的js文件。比如：

```
contextjs -
	account -
		account-config.js
		account-preview.js
```

这样当前端需要调试`account-config.html`文件时，模拟服务器会去读取`account-config.js`文件，
取得数据，然后传给模板，将模板渲染出来。
