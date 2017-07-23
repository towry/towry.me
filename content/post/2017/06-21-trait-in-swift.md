---
title: "swift中的trait使用方法"
date: "2017-06-21 13:34:53"
description: "trait in swift"
---

我对trait最好的理解是，trait是附加在一个类型上的可有可无的属性，丰富了原来的类型的特点。
PHP的trait是通过声明一个trait的结构，来为其他的类提供某些特性(我的理解，可能有偏差)。
swift可以通过声明一个结构（enum或者其他），代表一个trait。然后在protocol声明一个associatedtype，比如traitType,通过
这个traitType来和某个trait联系对应起来。再使用protocol的type contraint特性，将某个trait的特性
提供给这个protocol的“实现者”，但仅限于这个“实现者”带有这个trait，因为一个protocol是可以有
多个adopt（实现者）的。

比如一个protocol:

```swift
protocol SomeType {
	associatedtype TraitType // 和实现者的trait做对应
}
```

一个实现者:

```swift
struct SomeStruct<Trait> {
}

// Conform to the protocol
extension SomeStruct: SomeType {
	typealias TraitType = Trait // 对应起来
}
```

到这里，还没体现出trait的优势，上面的traitType等只是swift的generic编程中的普通例子而已。
要使用trait，我们需要借用swift的generic中的Type Constraint，类型约束。通过类型约束，
指定只有某个类型才享有某个特性。那么怎么类型约束呢？提供另外一个类型作为一个身份证。

```swift
// 两个起着身份标识作用的类型
enum IdA {}
enum IdB {}
```

然后我们要将这些身份证附给我们要使用的类型SomeStruct，让这个类型拥有不同的身份，不同的能力。
要这样做，我们不更改SomeStruct，而是通过扩展协议SomeType来达到目的。使用协议的
where语句来做类型的约束。

这里，我们说这个协议中的TraitType是IdA类型的话，它的sayHi方法要做的事情。

```swift
extension SomeType where TraitType == IdA {
	func sayHi() {
		print("IdA say hi")
	}
}
```

这里，我们说这个协议中的TraitType是IdB类型的话，它的sayHi方法要做的事情。

```swift
extension SomeType where TraitType == IdB {
	func sayHi() {
		print("IdB say hi")
	}
}
```

然后，我们可以使用SomeStruct了，因为SomeStruct已经遵从协议SomeType了。

```swift
let a = SomeStruct<IdA>()
a.sayHi()  // IdA say hi.

let b = SomeStruct<IdB>()
b.sayHi()  // IdB say hi.
```
