---
tags:
    - code
title: "Javascript hoisting"
date: "2014-04-08"
---

Here I am not talking about what hoisting in javascript is. I understand what the hoistingin javascript is, but not totally understood.

The simple case is when you declare a variable and initialize it in the same time, the declaration will be hoisted to the top, but the initialize will remain in the original spot.

```javascript
/** case 1 **/
var a = 2;

(function() {
  console.log(a);  // output 2
})();
/** end case 1 **/

/** case 2 **/
var b = 2;

(function() {
   console.log(b);  // undefined
   var b = 3;
})();
/** end case 2 **/
```

Why case 2 output undefined? didn’t we initialized the b in the top and under the console function?? Well, it’s because the second declaration&initialization, the declaration was hoisted to the top, but the initialization is still there, so the console function don’t know the value of b.
I have a complex example, I found it a few days ago.

```javascript
var fireOnce = function(fn) {
    var fired = false;

    return function() {
        if (fired) throw new Error("Callback was already fired.");

        fired = true;
        fn.apply(this, arguments);
    }
}

[1, 2, 3, 4, 5].forEach(fireOnce(function(v, i, a) {
    console.log(v);
}))
```

The expectation should be output one element from the array, then throw the error. but it just says the fireOnce is undefined. I think the reason is still because of hoisting. If I changevar fireOnce to function fireOnce, the script will pass the test. If it’s because of the hoisting, why the declaration&initialization in the same spot doesn’t work? I saw an explanation:The var declaration is hoisted to the function scope, but the initialization is not., I am not totally understand it now.

__Update__

OK, I think I know what’s going on here.

```javascript
var name = "world";
console.log(name);   // output world

(function() {
    if (typeof name === 'undefined' ) {
        console.log('fuck');
    } else {
        console.log(name);   // output world
    }

    console.log(' .. ' + name);  // output ... world
})();
```

The above code is ok, but we change a little.

```javascript
var name = "world";
console.log(name);   // output world

(function() {
    if (typeof name === 'undefined' ) {
        console.log('fuck');   // output fuck
                var name = 'Jack';
    } else {
        console.log(name);
    }

    console.log(' .. ' + name);  // output ... jack
})();
```

Now it’s interesting. Because what I thought is the execution is like water flow, after going into the function, it will check the name variable, surely it’s defined, so it will skip the next line , jump to else statement. but, the way the javascript interpreter is not working like what I thought!

The javascript interpreter have those code as input, it will not execute it immediately, it will hoist those declarations, and do some other work (which i actually not know). So, the javascript interpreter know the exists of var name = ‘Jack’, and hoisting it to the top! that’s the key point. the javascript doesn’t do the condition check when it hoisting declarations. after all those hoisting work done (or memory allocation work), then it begin execute the code like water flow, and when it(the interpreter) comes down to the condition check if ( typeof name === ‘undefined’ ), it look up the name variable in the memory, you probably think the value of variable name should be “world”. but, the value have changed when the interpreter check all declarations before the execution, and when the interpreter check all declarations, it just hoisting the declaration, the initialization of the variable which is name in this case, will still be there where it’s initialized. It’s fun, it’s not like pointer in C/C++, you just assign the address of a value in the memory to a variable, then in that scope, the program will know the value by the lead of the address. In javascript, program only know the value of a variable when the initialization appear before the variable name.

The above is what I thought again, but I think it’s much like that. I believe there is still some blind spot, and I appreciate it if someone tell me.
