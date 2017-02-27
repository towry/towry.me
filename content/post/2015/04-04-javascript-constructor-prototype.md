---
title: "JavaScript的constructor和prototype"
date: "2015-04-04"
tags:
    - code
---

这要从javascript函数说起，随便写一个javascript函数:

```javascript
function Foo () {}
```

首先，函数也是对象。Foo就是一个对象，是Object构造函数的一个实例。Foo instanceof Object等于true。然后，如果此时带入Function，那么就应该说，Function是Object的实例，而所有的函数都是Function的实例，因而函数也是Object的实例了。

```javascript
var b = new Function("console.log('b');");
b(); // 输出b
```

在上面的代码中，b是一个函数，所以可以被调用。在javascript中，每个函数都有一个prototype属性，这个属性值是一个对象。javascript就是依靠这个特性来实现继承的。

javascript中创建对象的一个方法是直接赋值{}，另一个是通过构造器来创建对象，也就是new函数。那么可以说这个函数就是构造器了，专门用于构造对象的。比如`var c = new foo();`那么c这个对象，有个prototype。但是我们直接是访问不了的，`c.prototype`会返回`undefined`值。Opera 10.50 以上支持一个非标准的`__proto__`来访问对象的`prototype`。有一个方法可以用来获取对象的`prototype`，就是`Object.getPrototypeOf`方法，不过这个IE上只有9以上支持。想要获取一个对象(object)的`prototype`，可以通过这个对象的`constructor`来获取。

我记得我刚开始了解javascript的继承时，看一些代码，用的都是`function a(){}, function b(){}, a.prototype = b.prototype, a.prototype.constructor = a;`我当时不懂，为什么非要讲这个constructor重新设置为原来的构造函数，现在知道，这是为了方便实例访问它的构造函数，如果一个构造函数的实例可以访问它的构造函数了，那么也就能访问这个构造函数上面的`protototype`原型了。

所以`c.constructor === foo`等于`true`，那么`c.constructor.prototype == foo.prototype`了。
