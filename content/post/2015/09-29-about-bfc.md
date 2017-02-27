---
title: "About BFC"
date: "2015-09-29"
tags:
    - code
---

这是我的关于 BFC 的一个理解。要很好的理清这个概念，需要了解什么是 块级盒子 以及
块级容器盒子。这里用到了盒子这个名词，这是<b>CSS盒模型</b>里面的概念。

## 块级盒子(block-level box)和块级容器盒子(block cotainer box)

块级盒子就是display为`block`，`list-item`，`table`的<b>元素</b>所生成的一个盒子，注意，这里是说
一个元素所生成的盒子，而不是说这个元素是盒子。块级盒子描述了其与父块级盒子和相邻块级盒子的行为。

块级盒子和块级容器盒子的关系是相交关系。对于table，可替换元素的块级盒子不是块级容器盒子。对于不可替换
的内联元素和不可替换的table cell元素是块级容器盒子，但不是块级盒子。所以，既是块级盒子又是块级容器盒子
的盒子有一个新的名称，叫块盒子（block box）。

## 块级格式化上下文

现在引用w3c的对于会计格式化上下文的描述：

> Floats, absolutely positioned elements, block containers (such as inline-blocks, table-cells, and table-captions)
> that are not block boxes, and block boxes with 'overflow' other than 'visible' (except when that value has been
> propagated to the viewport) establish new block formatting contexts for their contents.

翻译过来是： 浮动元素，absolute定位的元素，以及不是块级盒子的块级容器盒子（参考上面的解释），是块级盒子但其overflow的值是
visible以外的元素，这些元素会形成新的<b>块级格式化上下文</b>。

在这个环境中，里面的元素形成的盒子的布局会从上到下依次排列，然后这些盒子的左边会以这个块级容器盒子的边界为基准进行排列。这也就解释了一个例子，
就是一个浮动的图片，会被周围的文字所围绕。但是如果对包含这些文字的块级盒子（元素）应用`overflow:hidden`使其形成新的块级格式上下文的话，因为
盒子是正正方方的，所以里面的内容的左边会以这个块级盒子的左边为边界进行排列。

Figure1中，图片下面的文字直接从最左边开始进行排列。如果包含文字的那个盒子有新的块级格式化上下文环境的话，里面的内容就有新的排列参考对象，而不是参考其
周围的元素进行排列。也就是说，包含文字的盒子只关注它和其周围的盒子的排列布局，然后里面的内容的布局和盒子外面内容的布局是无关的。

```bash
.......   ,,,,,,,
. 图片 .   ,,,,,,,
.......   ,,,,,,,
,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,
     Figure 1
```

所以 Figure2解释了块级格式化上下文的<b>作用</b>

```bash
.......   ,,,,,,,
. 图片 .   ,,,,,,,
.......   ,,,,,,,
          ,,,,,,,
          ,,,,,,,
          ,,,,,,,
```
