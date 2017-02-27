---
title: "The form validation of angular"
date: "2016-04-04"
tags:
    - code
---

谈谈angular表单验证的复杂应用，其中利用了 angular 的 validators 。

最近项目里一个功能需要表单的验证，验证逻辑有点麻烦。本来的代码是使用了angular 表
单的 `ng-change`，然后调用一个函数来进行判断所有的字段是否合法，到最后测试的时候
发现逻辑已经变得很麻烦了，就像拧在一起的绳子，想要添加新的逻辑，不知从何处下手
安全。而且表单的错误提示信息用的是ng-if，来控制信息的显示，因此在 controller 里
面定义了大量的变量。到最后清扫bug的时候，发现大量的bug来源于此，因此决定重新写一
遍这个表单的验证。这个项目的功能是创建一个红包活动，其中的一个验证需求是需要用户
输入活动金额预算、一个红包随机金额的最小值和最大值。这些字段被其他字段影响，以及
被其他操作影响（比如添加其他限制）。

相对于先前的验证方法，这次我利用了 angular 这个框架本有的一些机制，让框架多做点，
自己少写些代码。使得验证步骤变得清晰起来，可以做到注释一个验证条件，不影响其他的
验证，我认为这是最好的了。

下面具体说一下是如何做的。金额的验证需要确定红包的最小值小于等于最大值，最大值不
能超过活动创建者（用户）设置的一个上线数字。而这个红包活动是基于腾讯微信开发的，
因此默认的区间是 0.01-200 元。而且当用户执行 “返回上一步”，然后再进入到这个页面
的时候，要保证数据还在并且需要再验证一次。旧逻辑是通过表单的 min 和 max 来控制
上下线的，因此输入数字过大，会使这个表单变成 invalid 状态并且有一个 error 对象。
关于如何在用户返回上一步再返回来的时候让表单验证并有 invalid 状态，旧逻辑是没有
的。最大金额和最小金额是两个互相影响的字段，活动总预算影响最小金额（最小金额太大
，总预算可能会不够，要确保总预算和最小金额的值可以至少能产生一个红包）。

表单的代码如下：

```html
<!-- 总预算 -->
<input type="number" name="total_money" ng-model="scopeObj.total_money" min="10"/>

<!-- 最小金额和最大金额 -->
<input type="text" name="range_min" ng-model="scopeObj.range_min" min="0.01" max="200" />
<input type="text" name="range_max" ng-model="scopeObj.range_max" min="scopeObj.range_min" max="200" />
```

旧逻辑是通过一个方法，当某个字段的值改变的时候，便进行全部的判断。这样的缺点是所
有的判断逻辑交叉在一个方法里面了，如果要更改或者删除，会非常的麻烦。而运用 angular
的 validators 的话，就会让代码变得非常简介和可配置，我只需要写一个 directive ，将
这个 directive 放到上面三个表单元素上面就可以了。

这个 directive 里面，通过 `ng-model` 来添加一些自定义的 validator 。

```javascript

angular.module('myApp')
  .directive('customValidator', function () {
    return {
      require: 'ngModel',
      restrict: 'A',
      link: function (scope, ele, attrs, ngModel) {

        ngModel.$validators.isMinBigThanTotal = function (modelValue) {
          // some parse, because the input's type must be text, not number
          var value = parseFloat(modelValue, 10);
          var limit = parseFloat(attrs.total, 10);

          // some logic here, to validate the value
          // return false if the validation failed.
          return true;
        }

        ngModel.$validators.isMaxSmallThanMin = function (modelValue) {
          // ommited
        }
      }
    }
  })

```

上面代码中的验证逻辑省略了，这些逻辑无非就是比较两个数字的大小，很简单。而这两个
数字的来源是，modelValue 是这个表单元素的输入值，另一个配合验证的数字来自于 attrs
。有了这些 validators，就可以将它们用于显示错误信息了，这里我用了 ng-messages 。

```html
<input type="number" name="total_money" ng-model="scopeObj.total_money" min="10"/>

<!-- 最小金额和最大金额 -->
<input type="text" name="range_min" ng-model="scopeObj.range_min" min="0.01" max="200" />
<input type="text" name="range_max" ng-model="scopeObj.range_max" min="scopeObj.range_min" max="200" />

<div class="messages-error" ng-messages="myForm.total_money.$error">
	<span ng-message="required" class="message">必填错误信息</span>
	<span ng-message="min" class="message">最小值错误信息</span>
</div>

<!-- 这里我用了或来显示错误信息，即当range_min和range_max有一个有错误信息的话就显示 -->
<div class="messages-error" ng-messages="myForm.range_min.$error || myForm.range_max.$error">
	<span ng-if="myForm.range_min.$error.isMinBigThanTotal || $myForm.range_max.$error.min" class="message">
		金额区间错误信息
	</span>
</div>
```

可以看到上面最后一个错误信息我用了 `ng-if` 而不是 `ng-message`，这是因为我认为这
两个错误信息是同一类的，只显示一次就可以了。

使用了新方法，可以看到，如果我删除一个验证，或修改一个验证，对另外的验证的影响是
非常非常小的。这样的另一个好处是，我可以手动出发表单的验证，就是让这些 validators
再运行一次，如果有错误，表单的状态就会被更新。比如当用户返回上一步，进行了操作，
增加了一个因素影响了 total_money，首先我会验证 total_money 的合理性，那么我可以
通过在 controller 里面，调用表单元素的 `$validate` 方法来重新验证这个表单元素，
即 `$scope.myForm.total_money.$validate()`，这个方法会重跑这个表单元素上的
validators。当这个total_money的值更新后，我需要再验证一下rang_min，可以通过上面
的方法来重新跑range_min这个表单元素的 validators，依次类推，保证验证逻辑的顺序
性，避免部分验证的漏缺。

好了，以上就是全部内容。
