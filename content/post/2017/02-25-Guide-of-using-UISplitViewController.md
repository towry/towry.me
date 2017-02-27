---
title: "UISplitViewController学习笔记"
date: "2017-02-25 21:26:00"
description: "UISplitViewController without storyboard"
---

想用`UISplitViewController`这个视图类来做一个界面类似iOS上的设置的项目，方便在上面添加其他的视图，进行一些实验性的调试，这样就不用一直创建代码了。在此过程中遇到很多的问题，现在都已经解决，感觉收获很大。在解决问题的过程中，我先尝试在Github上搜索一些`UISplitViewController`的sample，但是找到的都是通过`Storyboard`创建的项目，纯代码写的几乎没有。不过在那些项目里面，还是找到一些有用的例子。下面是一些我的基本理解。

## 简单介绍

首先要了解下`UISplitViewController`这个视图类的展示是什么样子的。用过iPad的都知道iPad的设置里，屏幕是分两列的，左边一个Table List,右边是具体的内容。在iPhone上我们很少看到这样的布局，这是因为iPhone的屏幕小，这样在竖着情况下显示两列明显空间不够，在横屏模式下就有可能看到两列布局了，这里涉及到了苹果系统上的size class特性，后面再说。split view controller 应用的标准架构是，用`UISplitViewController`作为`window`视图的`rootViewController`，然后用两个`UINavigationController`作为这个split view controller的子视图，放在split view controller的`viewControllers`里面。这两个navigation controller就是用来展示两列内容的。

## Collapse和Expand

在Apple的官方文档中，关于`UISplitViewController`会经常提到这两个关键字: `Collapse`和`Expand`，这是两种展示模式。在`Collapse`模式下，`viewControllers`数组个数是1，里面只有一个视图。在`Expand`模式下，`viewControllers`数组的个数是2。下面有一个表说明在什么设备上，怎样的方向上是`Collapse`模式，不是`Collapse`模式的就是`Expand`模式。

<table class="fn-with-courtesy">
  <thead>
    <tr>
      <th style="text-align: center">Device</th>
      <th style="text-align: center">Orientation</th>
      <th style="text-align: center">Multitasking state</th>
      <th style="text-align: center">Horizontal Size Class</th>
      <th style="text-align: center">Collapsed</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: center">iPad</td>
      <td style="text-align: center">All</td>
      <td style="text-align: center">Full Screen</td>
      <td style="text-align: center"><code class="highlighter-rouge">.Regular</code></td>
      <td style="text-align: center"><code class="highlighter-rouge">false</code></td>
    </tr>
    <tr>
      <td style="text-align: center">iPad</td>
      <td style="text-align: center">Landscape</td>
      <td style="text-align: center">2/3</td>
      <td style="text-align: center"><code class="highlighter-rouge">.Regular</code></td>
      <td style="text-align: center"><code class="highlighter-rouge">false</code></td>
    </tr>
    <tr>
      <td style="text-align: center">iPad</td>
      <td style="text-align: center">Landscape</td>
      <td style="text-align: center">1/2</td>
      <td style="text-align: center"><code class="highlighter-rouge">.Compact</code></td>
      <td style="text-align: center"><code class="highlighter-rouge">true</code></td>
    </tr>
    <tr>
      <td style="text-align: center">iPad Pro</td>
      <td style="text-align: center">Landscape</td>
      <td style="text-align: center">1/2</td>
      <td style="text-align: center"><code class="highlighter-rouge">.Regular</code></td>
      <td style="text-align: center"><code class="highlighter-rouge">false</code> (acts like portrait orientation)</td>
    </tr>
    <tr>
      <td style="text-align: center">iPad</td>
      <td style="text-align: center">Landscape</td>
      <td style="text-align: center">1/3</td>
      <td style="text-align: center"><code class="highlighter-rouge">.Compact</code></td>
      <td style="text-align: center"><code class="highlighter-rouge">true</code></td>
    </tr>
    <tr>
      <td style="text-align: center">iPad</td>
      <td style="text-align: center">Portrait</td>
      <td style="text-align: center">Split</td>
      <td style="text-align: center"><code class="highlighter-rouge">.Compact</code></td>
      <td style="text-align: center"><code class="highlighter-rouge">true</code></td>
    </tr>
    <tr>
      <td style="text-align: center">iPhone 6 Plus</td>
      <td style="text-align: center">Landscape</td>
      <td style="text-align: center">-</td>
      <td style="text-align: center"><code class="highlighter-rouge">.Regular</code></td>
      <td style="text-align: center"><code class="highlighter-rouge">false</code></td>
    </tr>
    <tr>
      <td style="text-align: center">iPhone 6 Plus</td>
      <td style="text-align: center">Portrait</td>
      <td style="text-align: center">-</td>
      <td style="text-align: center"><code class="highlighter-rouge">.Compact</code></td>
      <td style="text-align: center"><code class="highlighter-rouge">true</code></td>
    </tr>
    <tr>
      <td style="text-align: center">Other iPhones</td>
      <td style="text-align: center">Any</td>
      <td style="text-align: center">-</td>
      <td style="text-align: center"><code class="highlighter-rouge">.Compact</code></td>
      <td style="text-align: center"><code class="highlighter-rouge">true</code></td>
    </tr>
  </tbody>
</table>
<p class="fn-courtesy">
	Table courtesy of
	<a href="http://commandshift.co.uk/blog/2016/04/11/understanding-split-view-controller/">commandshift.co.uk</a>
</p>

由此可见，`Collapse`模式一般是设备的宽度过窄的时候出现的。这个也不难理解，因为宽度窄了，只能只显示一列而不是两列了。上面出现的两个关键字`Regular`和`Compact`，`Regular`是只正常宽度或者高度，`Compact`是紧凑宽度或者高度，这两个是属于iOS的size class特性中的，用于iOS的Autolayout，在此不多说。

## 展示视图

展示主视图的方法是`show(UIViewController, sender: Any?)`，展示副视图的方法是`showDetailViewController(_ vc: UIViewController, sender: Any?)`。当我们发送`showDetailViewController(_ vc: UIViewController, sender: Any?)`消息后，程序会在视图层(view controller hierarchy)里面，依次向上传递这个消息，直到某个视图可以处理这个消息。在这里只有`UISplitViewController`会处理这个消息，其处理这个消息的方式如下：

1. 如果当前的split view controller 是 expanded 模式，就是说宽度足够两列展示，那么split view controller 会接受这个要显示的视图，将它作为副视图展示出来。这个时候视图层的样子是两个navigation controller作为两列的第一视图，分别控制显示两列的内容。因此我们可以看到两列各有一个navigation bar。
2. 如果是 collapsed 模式。split view controller 会发送 `show(_:sender)` 消息到它的第一个视图控制器里，在本文的示例代码中（见文末），是一个`UINavigationController`。这个 navigation controller 收到这个消息后，会把这个要展示的视图给push到它的stack里面，于是这个视图就显示出来了。这个时候的视图层的样子是，第二个视图的navigation controller会作为子视图出现在第一个视图的navigation controller里面，这样第二个视图的内容就展示出来，只有一列。这样可能会有点奇怪，不过在内部实现上，第一个视图的navigation controller会做一些工作，保证正常显示第二个navigation controller里面的内容，而不显示第二个navigation controller的navigation bar。不然的话就有两个navigation bar了。在这里推荐阅读《Programming iOS 10 Dive Deep into Views..》这部书，里面有很详细的讲解。

## 其他

我发现，在设置`navigationController.isTranslucent = false`时，在显示的时候不生效，后来发现原因是我把这行代码写在了`navigationController`被添加为子视图的代码上面了。

```swift
// masterNavCtl?.navigationBar.isTranslucent = false
// detailNavCtl?.navigationBar.isTranslucent = false

masterNavCtl?.addChildViewController(ViewController())
detailNavCtl?.addChildViewController(DetailViewController())

// must set this after addChildViewController
masterNavCtl?.navigationBar.isTranslucent = false
detailNavCtl?.navigationBar.isTranslucent = false
```

代码例子: [UISplitViewController示例代码](https://github.com/towry/test-tabed/tree/master/calayer)
