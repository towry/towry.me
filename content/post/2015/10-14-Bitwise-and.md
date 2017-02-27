---
tags:
    - normal
title: "Bitwise and"
date: "2015-10-14"
---

```js

var ENUM = {
  A: 0,
  B: 1,
  C: 2,
  D: 4,
  E: 8,
  F: 16,
  G: 32
}

var c = ENUM.B + ENUM.D;

c & ENUM.C === 0
c & ENUM.B === ENUM.B
c & ENUM.D === ENUM.D
```

```js
function b (n) {
  return n.toString(2);
}

b(1) == 1
b(2) == 10
b(4) == 100
b(8) == 1000
b(16) == 10000
...
```
