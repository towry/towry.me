---
tags:
    - normal
title: "rust lifetime specifier"
date: "2016-05-04"
---

Give the following example:

```rust
struct A {}

fn foo<'c>() -> &'c A {
    let a = A {};
    &a
}

fn main() {
    let b = foo();
}

```

That code will not compiler, because variable `a` does not live as long
as function `foo`, since foo has a lifetime of `c`. After foo function is
called, the variable `a` will go out of scope.

To correct it,

```rust

struct A {}

fn foo<'a>(c: &'a A) -> &'a A {
    c
}

fn main() {
    let d = &A {};
    let b = foo(d);
}

```

This will work because d's lifetime is longer than function foo. and after
function main is out, the free sequence is like: free b -> free d. so d's
lifetime is bigger than b.
