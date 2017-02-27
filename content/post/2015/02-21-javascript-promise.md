---
date: "2015-02-21"
tags:
    - code
title: "JavaScript Promise"
---

The promise represents a future result of a task, the task can be completed immediately or in the future. It’s the alternate way to perform an action on a future result. For example, consider you are fetching a result from a remote server, when the request is done, you want to handle the success or error cases of that request. Your code would be like this:

```javascript
ajax.get({
  url: '/data.txt',
  success: function (data) { },
  error: function (data) {}
);
// or
ajax.get('/data.txt', function (data) {}, function (error) {});
```

There is nothing wrong with the above code. But there is a problem, it’s hard to read and what if you want to make changes on the data multiple times, you can pass multiple callbacks, but that would be a mess.

With promise, you can do things like this:

```javascript
phen.defer(function (resolve, reject) {
  var xhr = new XMLHttpRequest();
  // …
  xhr.onreadystatechange = function () {
  if (xhr.readyState === 4 && xhr.status == 200) {
    resolve(xhr);
  else {
    reject(xhr);
  }
}}).then(function (data) {
  data = data + 'extra data';
  return data;
}).then(function (data2) {
  console.log(data2);
});
```

The phen.defer function will return a promise object, then you give the promise a callback to be called when this promise is fulfilled. In this example, we add ” extra data” string to the original data then return it as data2. The second then method will receive the data2 and print it out.

So, how the above code works?

First, a task may be synchronously or asynchronously. For example, a for loop will be synchronously and a setTimeout will be asynchronously because setTimeout will be running when the current stack frame is empty[1.0].

When a task is asynchronously, the result of that task will not be available immediately. So we create a object called ‘promise’ and let it keep a value which is null initially, and a callbacks that will be called when the ‘promise’ has a wanted value or an error. So, how to add callback to callbacks in that promise? Expose an api method ‘then’, so we can add callback to that promise like this promise.then(function() {}). The ‘then’ method will be called immediately no matter the task is done or not. if the task is not done, then the callback in ‘then’ method will be added to promise, if the task is done, that’s mean the promise is fulfilled or rejected, then we should call the callback immediately. The ‘then’ method will return a new promise object to represent the result of next wanted result.

I have implemented promise in javascript called “phen”, it’s on [github](http://github.com/towry/phen). It’s very neat.

Notes

1.0 https://developer.mozilla.org/en-US/docs/Web/JavaScript/EventLoop
