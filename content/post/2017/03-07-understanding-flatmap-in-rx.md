---
title: "understanding flatMap in rx"
date: "2017-03-07 09:34:18"
description: "理解flatMap, 理解flatMapLatest, rxjs"
---

<em>注：此文针对的读者是了解了rx的一些基本概念，如果不了解，可以阅读这篇文章：[http://towry.me/post/2017/03-03-understanding-reactive-programming/#进入主题-反应式编程-reactive-programming](http://towry.me/post/2017/03-03-understanding-reactive-programming/#进入主题-反应式编程-reactive-programming)。
同时，此文中的stream和Observable sequence是同一概念。</em>

看官网或者其他文档对flatMap的解释是，会把原来的stream投射出的元素转换为另一个stream，然后最后
将这些stream合并为一个stream进行投射出来。所以，对于下面的代码，我的直觉认为，输出结果应该是：
`11, 12, 13, 21, 22, 23, 31, 32, 33`。但是在jsbin上运行输出后，输出的结果
是：`11, 12, 21, 13, 22, 31, 23, 32, 33`，虽然这肯定是正确的输出，但是不明白。

```js
// flatMap example
var stream1 = Rx.Observable.from([10, 20, 30]);
var stream2 = function(n) {
  return Rx.Observable.from([n+1, n+2, n+3]);
};

stream1.flatMap(function(n) {
  return stream2(n);
}).subscribe(function(n) {
  console.log(n);
}, function () {
  console.log('err');
}, function () {
  console.log('finished');
});
```

我绞尽脑汁想了想也不明白为什么`12`后面就是`21`了，而不是`13`。我去翻了翻 `rxjs` 的源码，想去
一探究竟，但是除了发现 `flatMap` 是 `mergeMap` 的别名外，似乎没其他收获。

后来我在代码里添加了一行输出：

```js
stream1.flatMap(function(n) {

  console.log("(" + n + ")");

  return stream2(n);
}).subscribe(function(n) {
  console.log(n);
}, function () {
  console.log('err');
}, function () {
  console.log('finished');
});
```

现在输出结果变成了：`(10), 11, (20), 12, 21, (30) 13, 22, 31, 23, 32, 33`，从这个输出中
我立马发现了一些东西，然后明白这个flatMap后的stream投射方式是怎么样的了。

第一个stream1，在投射元素的时候，通过flatMap会将投射出的元素转换成stream，我们称为stream2-1，
因为它是stream2的第一部分。这个时候，投射图是这样的:

```
-10------------------> stream1时间线
---11-------------------> stream2-1时间线，比stream1差一个时间点。
// (10), 11
```

也就是说，10 转换出来的 stream2-1也立马开始投射它自己的元素了，先紧跟 stream1 投射出来的10，
投射出11,毕竟stream2-1是10转换出来的。10这时转换完成了，紧接着20开始转换，转换出的stream我们
称为stream2-2。在这个时间点上（20转换的点上)，stream2-1已经开始投射12，然后stream2-2转换出来了
并投射21，所以有下面的图：

```
-10---20---------------> stream1时间线
---11-12-----------------> stream2-1时间线
--------21---------------> stream2-2时间线

// (10), 11, (20), 12, 21
```

这时stream1剩余最后一个元素，30，紧跟着20的投射转换后，也开始转换，这个点上，stream2-1开始投射
13，并且stream2-2开始投射22，这两个投射完后，转换完成的stream2-3开始投射元素31，所以有下面的图：

```
-10---20---30------------> stream1时间线
---11-12---13------------> stream2-1时间线
--------21-22------------> stream2-2时间线
-------------31-----------> stream2-3时间线
// (10), 11, (20), 12, 21, (30), 13, 22, 31
```

到这里应该就很容易理解了。flatMap最后flat的是stream2中投射出来的，stream2是由stream2-1,
stream2-2,stream2-3投射出来的元素组成。

## 扩展理解 flatMapFirst 和 flatMapLatest

> flatMapFirst instead propagates the first Observable exclusively until it completes before it begins subscribes to the next Observable.

从这里也可以很好的理解`flatMapFirst`了。假如stream1中的元素都是网络请求，10代表网络请求发出
去了，而由10转换出来的stream2-1代表着整个和这个网络请求相关操作，也就是可以认为stream2-1代表着收到网络
请求结果后，对数据处理，更新界面等等。然后这时，20开始投射并进行转换为stream2-2，这可能代表着
用户再次发送了一个网络请求，这个时候，从上面的图中可以看出，20转换出来的stream2-2开始投射的时候，
stream2-1已经投射到了12了，这个12可以代表着stream2-1发出的网络请求已经返回结果，要对结果进行
处理。而stream2-2这时候的开始，明显是一个重复的网络请求操作，是应该被取消的，毕竟第一个网络请求
还没被处理完成呢。这个时候使用`flatMapFirst`，会取消后续(stream2-2)的操作，因为第一个操作(stream2-1)还没有完成。
然后理解 `flatMapLatest` 也就不难了，就是要取消stream2-1(未完成)，使用stream2-2（最新的）。这时如果用户
不小心又触发一个网络请求(stream2-3)，那么`flatMapLatest`会取消`steram2-2`，使用`stream2-3`。
当然，在这样的场景下，我们是应该使用`flatMapFirst`的！

好了，基本就是这样，文字写的可能有点烂，但是希望能帮助别人理解。
