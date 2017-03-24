---
title: "xstream源码分析"
date: "2017-03-24 17:56:44"
description: "xstream源码解析, xstream源码分析"
---

xstream和rxjs类似，都是reactive programming在js上的实现。不过xstream比较轻量级一点，特别为cyclejs做了兼容。我这两天看了一下xstream的源码，尝试理清xstream的工作原理。

## Stream

在xstream中，Stream代表着产生序列的对象的类，同rxjs中的Observable是一个概念, xstream的作者staltz在[一篇文章](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754#reactive-programming-is-programming-with-asynchronous-data-streams)中也介绍了Stream这个概念。因为我们说Stream对象是一个产生序列的对象，那么我们可以说Stream对象会发射元素。

## 设计模式pub/sub

xstream是使用`publish/subscribe`设计模式来工作的。因为Stream对象是一个产生序列的对象，所以需要一种机制来告诉其他依赖方数据有产生，或者错误有产生。使用publish/subscribe设计模式，就是为了监听当Stream对象有变化时，可以通知其他监听者们。在xstream中，Stream会充当publisher的角色，维护一个监听者列表。

## 主要接口类型

xstream里有几个主要的接口类型，其中有`Producer`, `Listener`, `InternalListener`, `InternalProducer`。其他的接口类型比如`Subscription`我们可以看成是辅助类型，这里不提也巴。

[Producer](https://github.com/sourcemd/xstream/blob/0a636f1a506afb99eef441e88f01f7bc0e860442/src/index.ts#L66) 类型代表着序列产生器，是发射元素的地方。其有一个`start`和`stop`方法，表明如何发射元素和如何停止发射元素。我们可以说`{start: function () {}, stop: function () {}}`这个对象是一个`Producer`类型的对象，因为它遵循了`Producer`这个接口。

`Listener` 类型代表这监听者，有3个属性方法, `next`, `error`, `complete`，用于有元素发射的时候，分布作为callback被调用，`error`是只有错误发生是才会被调用。

而`InternalListener`和`InternalProducer`是xstream内部实现上依赖的类型。比如`InternalProducer`就是被`FromArray`继承，用于创建特殊的`Producer`，如果你用`xs.from([1,2,3])`或者`xs.of(23)`方法来创建一个`Stream`对象，那么其会先创建一个`FromArray`对象（继承`InternalProducer`)，[FromArray](https://github.com/sourcemd/xstream/blob/0a636f1a506afb99eef441e88f01f7bc0e860442/src/index.ts#L427)的`_start`方法会依次发射你传给其的数组中的元素`1,2,3`。我们可以看见，`FromArray`对我们是不可见的，只是一个方便创建`Producer`的辅助类。另外的`xs.fromPromise`方法也是，会创建一个`FromPromise`的producer，传给`Stream`构造函数，进而创造`Stream`对象。
这是xstream内部为我们创建的producer，如果我们要手动创建，可以使用`Stream`类的`create`静态方法，`create`方法接受一个`Producer`类型的对象，即有一个`start`和`stop`方法的对象。你可以在`start`方法里指明怎么发射元素，比如可以：

```js
xs.create({
  start(listener) {
    for (var i = 0; i < 10; i++) {
      // 发射元素了!!!!，通知监听者
      listener.next(i);
    }
    // 当然，如果有错误，可以通知监听者有错误发生
    listener.error(new Error("some error"));
  },
  stop() {
    // ...
  }
})
```

## Stream 和 pub/sub

Stream 实现了 [InternalListener](https://github.com/sourcemd/xstream/blob/0a636f1a506afb99eef441e88f01f7bc0e860442/src/index.ts#L33)协议，这并不是说Stream是一个监听者(listener|subscriber)，相反，Stream是一个 publisher，其内部维护了一个`_ils: Array<InternalListener<T>>`变量，用于存储监听者，这个变量是一个数组，里面的元素类型是`InternalListener`。还有一个 [subscribe](https://github.com/sourcemd/xstream/blob/0a636f1a506afb99eef441e88f01f7bc0e860442/src/index.ts#L1341)方法，该方法用于添加监听者(listener)到`_ils`里面。

`subscribe`方法是这样工作的，调用`addListener`方法，然后会返回一个`StreamSub`对象，这个对象的作用是方便删除当前添加的监听者，这里不多说，看源代码会很容易明白。然后我们具体看`addListener`方法，这个方法会将监听者(Listener类型)添加到`_ils`里面。但是`ils`里面的元素类型是`InternalListener`，所以`addListener`这个方法还要进行[类型的转换](https://github.com/sourcemd/xstream/blob/0a636f1a506afb99eef441e88f01f7bc0e860442/src/index.ts#L1318)，转换完类型后，会调用内部私有方法`_add`，这个方法才真正添加监听者到`_ils`里。

`_add`方法先添加监听者到`_ils`里面后，会先判断`_ils`的长度，如果`_ils`里面只有一个监听者，那么其会开始发射序列的元素。也就是说，Stream会在添加第一个监听者的时候便开始发射元素。

待续...
