---
tags:
    - normal
title: "flow build QA"
date: "2016-08-19"
---

* 如何知道上次发布的commit id

	1. 每次发布完，都向数据库中记录上次发布的commit id, 分支等信息
	2. 在发布项目中的某个干净文件中，记录上次发布的commit id，分支等信息

* 如何确定这次要发布的更改的文件有哪些

	知道上次发布的commit id后，扫描自上次commit后更改过的文件列表，记录在要build的文件队列中

* 如何确定整个项目依赖树

	每次发布，扫描 src-page 目录下js，less，构建整个依赖树。这样做是因为有些被共用
的js或者less文件更改后，可能有好几个文件都要被重新build。


总结：
	因为是使用了commonjs的方式，所以需要这样做。如果是amd的方式，只需要build每个文件就可以。
但是amd方式请求数太多，不理想。
