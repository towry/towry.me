---
title: "switchLatest in rxjs"
date: "2017-03-08 09:30:13"
description: "switchLatest, switch in rxjs, rxswift"
---

Given the following js code:

```js
var stream1 = Rx.Observable.from([10, 20, 30, 40, 50, 60, 70, 80]);
var stream2 = Rx.Observable.from([11, 21, 31, 41, 51, 61, 71]);
var stream3 = Rx.Observable.from([12, 22, 32, 42, 52, 62, 72]);

let source = Rx.Observable.of(stream1, stream2, stream3);

source.switchLatest().subscribe(function (a) {
  console.log(a);
})
```

output:
```
10, 11, 12, 22, 32, 42, 52, 62, 72
```

The explanation of `switchLatest` from official documentation:

> convert an Observable that emits Observables into a single Observable that emits the items emitted by the most-recently-emitted of those Observables

So, source will emit Observable, if we subscribe to source:

```js
source.subscribe( .... );
```

Then source will emit three item and each item is an observable: stream1, stream2, stream3.

So when stream1 is emitted by source, then stream1 starts to emit item 10. meanwhile stream2 is emitted by source, then stream1 starts to emit item 20 and stream2 starts to emit item 11, mean while stream3 is emitted by source, then stream1 starts to emit item 30, stream2 starts to emit item 21 and stream3 starts to emit item 12. You have noticed that the three observable is emitted one by one, each one is emitted, `switchLatest` operator will treat the latest observable as the `current single observable` that emit item. So the `current single observable` first is stream1, then stream2, then stream3, and after that it is stream3 all the way to the terminal of stream3.

`switchLatest` will only emit item that emitted by the `current single observable`. that is why 20 is dropped once stream2 become the `current single observable`.
