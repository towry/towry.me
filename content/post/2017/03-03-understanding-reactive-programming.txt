---
title: "深刻理解 reactive programming"
date: "2017-03-03 14:54:37"
description: "understanding reactive programming, 深刻理解 reactive programming, rxjs"
---

## 从指令式编程到反应式编程

### 指令式编程和函数编程

1. imperative programming, 指令式编程，程序员需要写出每一条指令（步骤），直到可以达到计算的目的（比如更改某状态），所以也可以叫做 algorithmic programming（逻辑编程）。
2. functional programming（纯函数），将解决问题的方法分为几个可以执行的函数，你定义输入，然后传入给这些函数，这些函数给你输出。所以函数关注的是如何转变输入为正确的输出。一个函数可以代表一个值，数据，对象。

相比之下，指令式编程的从上到下的执行或者从状态A到状态B的转变，使得它更关注于前面的状态是什么，状态目前是什么，状态将来是什么。在指令执行过程中可能会依赖其他的东西来记录状态的改变。

而（纯）函数是无状态的，它不关注状态是什么，它只关注如何转变(transform)，仅此而已。所以函数不依赖外部的状态。我们都知道，依赖越少越好。它可以用来写 mathematical function 。我们知道数学公式都是给一些参数会产生一个值（就是转变, transform），这个公式是没有依赖的。我们平时写的函数一般都是 procedure，这些函数都不纯，会修改外面的某状态，或者依赖外面的某状态，里面都是些指令式的代码，完全不像数学公式。

|Characteristic	| Imperative approach	| Functional approach |
| ------------- | -------------------- | ---------------------|
|Programmer focus | How to perform tasks (algorithms) and how to track changes in state. | What information is desired and what transformations are required. |
|State changes | Important. | Non-existent. |
|Order of execution | Important. | Low importance. |
|Primary flow control | Loops, conditionals, and function (method) calls. | Function calls, including recursion. |
|Primary manipulation unit | Instances of structures or classes. | Functions as first-class objects and data collections. |

### 事件编程 (event driven programming)

事件编程是和 procedure 有关的。我们知道一些程序里喜欢用 goto 语句，比如有一个 if false then goto somewhere。这种控制的缺点是代码很容易变得chaotic（混乱），我相信这很容理解和有所体会。而事件编程是，将某些控制交给事件处理，也就是说某些事件发生才调用某些 procedure。比如点击按钮触发一个点击事件然后调用某个处理函数。事件编程的好处是，直观，适用于一些依赖外部事件的应用，比如某应用需要依赖外部的io返回的结果。方便切换执行上下文，试想在并发编程中，单线程，某代码可能被挂起(pause)或者继续(resume)，或者结束，而这三种改变可以通过事件来管理。

### declarative programming(声明式编程):

代码描述了你要做什么，而不是你怎么要去做它。举一个例子就可以立马明白：SQL。哈哈哈哈哈哈哈。

其实不是这样的，因为 reactive programming 属于声明式编程的一种，所以这里应改重点介绍一些，而不是SQL一带而过。我对reactive programming最初的理解是，这是种对值的一种描述，你从这个描述中就可以很清晰的看到这个值是怎么转变为另外的值的。

而在其他文档中，对其描述是这样的。expresses the logic of computation without describing it’s control flow。这句话是什么意思呢，我的理解是，代码的复杂性就是因为太多的控制转换，导致分不清代码逻辑。而如果一个值的计算可以包含逻辑而无控制转换的参与，会提高代码的可阅读性和维护性，同时减少[副作用](https://en.wikipedia.org/wiki/Side_effect_(computer_science))。那么如何达到这样的目的呢，就是通过描述为了解决这个问题，代码必须要做的事情。而不是描述代码如何做到那件事情。这个解释就和上面的第一句相同了。那么什么是代码必须要做的事情呢，就和推导有关了。给一个表达式，推导出一个值，然后应用另一个表达式，输入这个值再推导出另外的值。正则表达式就是声明式代码。你给一个正则表达式，描述了代码（执行正则的代码）要做的就是如何匹配到某个字符串，而不是如何去匹配到这个字符串。如何去匹配到这个字符串是执行正则的代码要做的。执行正则的代码可能会通过很多 if else 来匹配每个字符，然后最后判断是否匹配，其中肯定参与很多的状态的改变和记录，这些都是对我们使用正则的人不可见的，可见的都是清晰的表示某值（匹配到的值）的正则表达式。

### Dataflow Programming

传统代码都是由有序的执行代码块组成的，代码块有序的运行。数据流编程关注的是数据的移动，在代码块中移动，如果有代码块收到这个数据后，确认是满足运行的条件的就会运行。也就是说这些代码块可能是并行运行的，数据不会说先进入这个代码块运行，然后根据这个代码块的返回结果然后再进入下一个代码块。不是的，数据像流水一样，流过这些代码块，在同一时间范围内触发这些代码块的反应。有些代码块会忽略这个数据，因为这个数据不是它所能处理的。有些代码块可能说这是我可以处理，我要处理的数据，我要开始处理运行了。因此这样的工作方式是没有中心的，所有代码块的运行是要被触发的，是被数据触发的，是可以在某一时间范围内同时触发的。因此它天生是可并行的。

这里有一个比较形象的比喻。看过卓别林的“城市之光”这部喜剧片的一定对工人们在组装线上单调重复，千篇一律的工作有所印象。在组装传送带上会有零件经过每个工人，然后工人各司其职，对这个零件进行处理加工，如果某个零件不属于这个工人要处理的零件种类的话，那么这个工人可以忽略这个零件，不处理它。在这里，代码块就像工人一样，而零件就是数据。工人们都在并行的工作着。

## 进入主题，反应式编程(reactive programming)

​说到dataflow programming，其实和reactive programming很接近了。而reactive programming又是dataflow programming的一种。

reactive programming，顾名思义就是可反应编程。在传统编程范式中，`a=b+c`，运行后，a的值就是 b 和 c的值相加。然后a的值就确定了。此后，b 和 c 的值再改变，已经和 a 无关了，所以 a 不会再更改，除非你再运行一下这个表达式。而反应式编程是要a的值会随着b和c的值的更改而更改，有点类似a在监听b和c的改变，一旦某一个改变，那么就根据上面的表达式更改a的值。从这个特点来看，反应式编程很适合 data binding，用在实时应用中非常好。

在实现上，现在很多语言都是通过第三方库来支持在该语言上的reactive programming。比如 reactive extentions (rx) 就是reactive programming在各个语言上的扩展应用。

我们说过反应式编程是数据流编程的一种，因此其处理的也是一个数据流(data sequences，其他也称为stream)。一个数据流可以是网络上的一个请求，文件读取，系统通知，或者用户触发的点击事件。

rx 将这些数据流（stream）看作是 observable sequences，即可观察的有序序列，这只是技术名词的生硬翻译。在这里我有一个理解就是，一个stream，就是一个可能随时变化产生新值的一个变量，属性或对象等等。而staltz有一个说法是，stream是一个有序对象，里面每个元素是正在进行的多个事件。这个有序对象会依次在这些事件中产生1个值，这个值的类型可能是一个正确的值，一个错误，一个完成的信息。这个有序对象可能是有限的(finite)，也可能是无限的(infinite)。也就是说它可以持续产生一个值，直到它产生一个错误或者完成信息后才停止，一旦停止就不会才被启动了。结合读取文件流这个例子就可以很好的理解了，文件流的读取就是有3个类型值产生，内容块，错误，文件已经读取完。每次有新的bytes的时候就是有内容的事件，当读取错误的时候也是一个事件，只是这个事件产生错误的值。

回到Rx，Observable这个类，可以看作一个用来生成observable sequences（可观察对象）的类，所以我们可以说一个observable sequence是一个Observable类型的对象。然后我们向这个对象里面push一个个observer（观察者，用来观察这个可观察对象），然后这个可观察对象会在启动的时候，将数据依次流过这些observer，observer就收到有数据的通知，然后进行处理。这些observer是用来监听这个stream（observable sequence）的，而这个stream（observable sequence）因而就是一个可观察的对象(Observable）。

以用户点击按钮为例，创建一个Observable对象，用来表示用户点击的事件流。当用户不断点击的时候，这个事件流就可以看作 `[click1, click2, click3, click4, … 随着用户点击不断增加]`，这是有序的，毕竟用户点击时间是有先后顺序的。如果你在开始的时候就向这个Observable对象push一个observer观察者，那么这个观察者就会在每次点击事件中收到通知。

```js
var clickStream = Rx.Observable.fromeEvent(button, ‘click’);
```

上面创建了一个Observable对象，代表这有序的事件流。我们可以push一个observer，来监听这个事件流。

```js
clickStream.subscribe((event) => {
	console.log(event);
});
```

上面我们调用`subscribe`，传入了一个函数进去作为observer的处理函数，当有事件的时候，会收到一个值，
这个值是一个浏览器的`event`对象。因为我们给`subscribe`传入了一个函数，那么这个函数收到的值肯定是一个
值，而不是一个错误或其他。因为`subscribe`接受3个参数，后两个参数是用来处理有错误，和完成的。后两个参数
可以省略，如果我们只想收到可以 emit 值的事件的通知的话。如果你传入第二个函数，表示你想收到当某事件emit错误信息的通知。

上面的代码很像我们写的事件订阅啊，其实rx的强大在于 operators。你可以利用 operators 将原来的stream转变会其他的
stream。

```js
var singleClickStream = clickStream
    .buffer(function() { return clickStream.throttle(250); })
    .map(function(list) { return list.length; })
    .filter(function(x) { return x === 1; });
```

你可以使用`singleClickStream`。

```js
singleClickStream.subscribe((event) => {
	console.log(event);
})
```

这样，你的observer只会收到经过满足特定条件的事件的通知，更棒的是这些都是直观的体现在了声明开始的地方。

一个Observer是由三个属性构成的，`onNext`, `onError`, `onComplete`。当你调用observable对象的
`subscribe`方法时，其实是向里面push一个observer对象。我们只是传递三个参数，然后rx会用这三个参数创建
一个`observer`对象放到订阅列表中，当有事件的时候，rx会调用这个`observer`的方法来处理“有值”，“错误”，“完成”三种情况。
因此我们可以自定义，当有事件的时候，这个observer怎么决定应该是`onNext`,还是`onError`。

```js
var source = Rx.Observable.create(observer => {
  // Yield a single value and complete
  observer.onNext(42);
  observer.onCompleted();

  // Any cleanup logic might go here
  return () => console.log('disposed')
});

source.subscribe((value) => {
	console.log(value); // 42
}, () => {
	console.log('error happend');
}, () => {
	console.log('completed');
})
```

---

## References

1. https://msdn.microsoft.com/en-us/library/mt693186.aspx
2. https://en.wikipedia.org/wiki/Dataflow_programming
3. https://en.wikipedia.org/wiki/Reactive_programming
4. https://xgrommx.github.io/rx-book/
5. https://gist.github.com/staltz/868e7e9bc2a7b8c1f754
