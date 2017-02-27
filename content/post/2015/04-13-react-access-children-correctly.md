---
title: "React – Access children correctly"
date: "2015-04-13"
tags:
    - code
---

Component in React can have other component as it’s child, for example:

```javascript
var MyComponent = React.createClass({
  render: function () {
    return this.props.children;
  }
})

var App = React.createClass({
  render: function () {
    return (
      <MyComponent>
         <p>hello world</p>
         <MyComponent><span>Hello again</span></MyComponent>
      </MyComponent>
    );
  }
})
```

In the above code, we have components in component, to access the children, we can use React.Children.map function, the function takes three arguments: children, callback, context. In the callback, there will be an argument whose value is the current child, to determine if that child is created from other component, we can use the following method:

```javascript
var MyComponent = React.createClass({
  getChildrens: function () {
    return React.Children.map(this.props.children, function (child) {
      if (child.type === MyComponent) {
        // So, the child is a ReactElement whose constructor is MyCompoennt
        // you can transfer the props to this child
        // https://facebook.github.io/react/docs/clone-with-props.html
        React.addons.cloneWithProps(child, this.props);
    }, this);
  },

  render: function () {
    return this.getChildrens();
  }
})

var App = React.createClass({
  render: function () {
    return (
      <MyComponent>
         <p>hello world</p>
         <MyComponent><span>Hello again</span></MyComponent>
      </MyComponent>
    );
  }
})
```
