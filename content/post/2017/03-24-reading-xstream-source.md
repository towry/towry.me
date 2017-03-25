---
title: "xstream源码分析"
date: "2017-03-24 17:56:44"
description: "xstream源码解析, xstream源码分析"
---

xstream和rxjs类似，都是reactive programming在js上的实现。不过xstream比较轻量级一点，特别为cyclejs做了兼容。我这两天看了一下xstream的源码，尝试理清xstream的工作原理。

先看一个图，我不会画UML图，所以只是凭感觉画了一下，这里会解释下图中元素代表的含义。

![xstream diagram](/storage/images/2017/xstream_diagram.jpg)

stream拥有producer和listeners。producer用来发射元素，并且producer有一个指向stream的引用。当producer发射元素的时候，会使用这个引用，调用stream的`_n`私有方法，然后stream再去通知listeners中的listener。

## 基本概念

### Stream

在xstream中，Stream代表着产生序列的对象的类，同rxjs中的Observable是一个概念, xstream的作者staltz在[一篇文章](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754#reactive-programming-is-programming-with-asynchronous-data-streams)中也介绍了Stream这个概念。因为我们说Stream对象是一个产生序列的对象，那么我们可以说Stream对象会发射元素。

### 设计模式pub/sub

xstream是使用`publish/subscribe`设计模式来工作的。因为Stream对象是一个产生序列的对象，所以需要一种机制来告诉其他依赖方数据有产生，或者错误有产生。使用publish/subscribe设计模式，就是为了监听当Stream对象有变化时，可以通知其他监听者们。在xstream中，Stream会充当publisher的角色，维护一个监听者列表。

### 主要接口类型

xstream里有几个主要的接口类型，其中有`Producer`, `Listener`, `InternalListener`, `InternalProducer`。

* [Producer](https://github.com/sourcemd/xstream/blob/0a636f1a506afb99eef441e88f01f7bc0e860442/src/index.ts#L66) 类型代表着序列产生器，是发射元素的地方。其有一个`start`和`stop`方法，表明如何发射元素和如何停止发射元素。我们可以说 `{start: function () {}, stop: function () {}}` 这个对象是一个`Producer`类型的对象，因为它实现了`Producer`这个接口。
* [Listener](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L71) 类型代表着监听者，有3个方法, `next`, `error`, `complete`，所以当stream有发射元素的时候，会通知监听者，通知方式是调用监听者的`next`方法，将元素值作为参数传进去。如果stream有error，则会调用监听者的`error`方法。
* [InternalProducer](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L45)，这是xstream内部实现上依赖的"Producer"接口类型。这个接口有两个方法，`_start`，`_stop`。这两个方法除了调用`Producer`接口的`start`和`stop`方法外，还会做些[额外的工作](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L86)，`Stream`在工作的时候，会调用`InternalProducer`的`_start`方法来开始发射元素，进而调用了`Producer`的`start`方法。
* [InternalListener](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L33)，这个接口的作用同 `InternalProducer`接口的作用类似。这个接口是对`Listener`的封装，做了一些额外的工作。其有`_n`, `_e`, `_c`三个方法，会分别调用`Listener`的`next`, `error`, `complete`。

## 工作原理

先看下[Stream](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L1179)类的实现。

```js
export class Stream<T> implements InternalListener<T> {
  public _prod: InternalProducer<T>;
  protected _ils: Array<InternalListener<T>>; // 'ils' = Internal listeners
  protected _stopID: any;
  protected _dl: InternalListener<T>; // the debug listener
  protected _d: boolean; // flag indicating the existence of the debug listener
  protected _target: Stream<T>; // imitation target if this Stream will imitate
  protected _err: any;

  constructor(producer?: InternalProducer<T>) {
    this._prod = producer || NO as InternalProducer<T>;
    this._ils = [];
    this._stopID = NO;
    this._dl = NO as InternalListener<T>;
    this._d = false;
    this._target = NO as Stream<T>;
    this._err = NO;
  }
  // ....
}
```

其内部有一个`_prod`，是一个`InternalProducer`对象，是发射元素的地方。还有一个重要的变量是`_ils`，上面的注释也解释了`_ils`代表着什么，是代表着监听者列表。所以如果`_prod`发射元素的话，会通知(并非直接通知)这些监听者们。其他的变量我们可以先不看。我们可以看见`Stream`类也继承了`InternalListener`，因此我们也可以把它看作是一个监听者，监听这个`_prod`。或者说`Stream`是一个监听者代理，在`_prod`和`_ils`中间，当`_prod`有元素的时候，通知的是`Stream`，然后`Stream`会再去通知`_ils`监听者们。

我们看一段示例代码来解释`Stream`从开始到完成。

```js
var stream1 = xs.from([1,2,3,4]);
stream1.subscribe({
  next(value) {
    console.log(value);
  },
  error(err) {
    console.log(err);
  },
  complete() {
    // ...
  }
})
```

首先，`xs.from`方法会创建一个`Stream`对象，然后我们调用了`Stream`对象的[subscribe](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L1341)方法，并传入一个`Listener`类型的监听者对象。`subscribe`方法会先将这个监听者加入到`_ils`列表里面，然后判断，__如果只有一个监听者的话，会直接调用`_prod`的[_start](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L1262)方法__，并将当前的`Stream`对象作为参数传进去。传进去的作用是为了方便`_prod`在有元素的时候，通知这个`Stream`对象。

可能有人有疑问了，如果在第一个监听者添加进去的时候，便调用producer的start方法，那后面添加进去的监听者怎么被通知到呢？是这样的，如果在__同步__情况下，你通过Stream的`subscribe`添加一个监听者进去，producer会立马发射元素，并调用Stream的[_c](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L1222)方法（代表着complete，这个方法会调用监听者的`complete`方法)，即表明这个producer已经发射完成了。而这个`_c`方法会调用Stream的私有方法`_x`，`_x`的作用是在producer发射完成后进行清理工作，会清空监听者列表`_ils`这个数组，置为空数组，并重置Stream类的状态。所以你下次再添加一个监听者时，你的监听者列表里还是只有一个监听者，因此producer会再次启动发射元素。在__异步__情况下，你多次添加监听者的时候，producer的`_start`方法被调用，但是还未开始发射元素，比如producer正在等待网络请求的返回。因此这个时候Stream的监听者列表`_ils`可能会有多个监听者。而producer一旦开始发射元素，便会通知Stream，然后Stream会依次通知监听者列表里面的监听者。

我们在调用`xs.from`并传入一个数组的时候，`from`这个静态方法会先创建一个[FromArray](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L419)这个producer，`FromArray`继承了`InternalProducer`。创建这个producer后，会作为参数传给`Stream`类的构造函数，作为Stream的`_prod`，因此Stream对象在调用`_prod`(FromArray)的`_start`方法的时候，FromArray所做的就是循环数组，然后调用`Stream`的私有方法`_n`，而`_n`会循环Stream的`_ils`列表，调用其中的listener的`next`方法，真正的监听者就收到通知了。

上面的`FromArray`是xstream内部创建`producer`的简单方法。如果我们想自己创建一个`producer`，来指明怎么发射元素，可以使用`xstream`的`create`这个静态方法。

```js
var stream1 = xs.create({
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
});

stream1.subscribe({
  next(v) {
    console.log("我收到通知了!!!", v);
  }
})
```

`create`接受一个`Producer`类型的对象，然后使用[internalizeProducer](https://github.com/sourcemd/xstream/blob/master/src/index.ts#L1368)方法，将其转换为`InternalProducer`，传给`Stream`的构造函数作为Stream的`_prod`变量，进而创建一个`Stream`对象。当你`subscribe`一个监听者listener到这个Stream对象的时候，上面的`start`方法就会被间接的调用，进而监听者listener就会被通知到了。

## 总结

所以，在xstream中，`Stream`既充当着publisher的角色，又充当着`subscriber`的角色。同时，我们也可以简单的一句话概括xstream或者rxjs的工作方式，即：创建producer，指明怎么产生元素。创建stream，用户添加监听者到这个stream。stream监听producer，然后通知用户的监听者。
