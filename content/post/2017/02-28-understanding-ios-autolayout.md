---
title: "Understanding iOS autolayout"
date: "2017-02-28 02:00:20"
description: "理解 ios autolayout"
tags:
 - ios
---

今天看资料学到 iOS 的自动布局，资料上介绍的都很详细，但是有些地方总是有些疑惑，尤其是参照资料上的代码写出来以后，发现什么都不显示，更觉得困惑了。后来我调整了代码中布局的某些位移，才发现视图不显示的原因，并且理解了自动布局的计算公式是什么意思。

关于iOS的自动布局详细介绍，可以参考官网文档。同时，建议了解下自动布局 `autolayout` 和 `autoresize` 的区别。

## 示例介绍

现以示例代码来说明我遇到的困惑和原因，可能会帮到你理解自动布局。

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .blue

    let v1 = UIView()
    v1.backgroundColor = .cyan
    self.view.addSubview(v1)

    v1.translatesAutoresizingMaskIntoConstraints = false

    // left, 左边
    self.view.addConstraint(NSLayoutConstraint(item: v1, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 20.0))
    // right, 右边
    self.view.addConstraint(NSLayoutConstraint(item: v1, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -20.0))
    // bottom, 底部
    self.view.addConstraint(NSLayoutConstraint(item: v1, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -20.0))

    // height, 高度
    v1.addConstraint(NSLayoutConstraint(item: v1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 20.0))
}
```

`v1` 是 `self.view` 的一个子视图。上面的代码是没有任何问题的。`v1`视图会以高度20，然后和父视图底部距离20，左右距离20的方式呈现出来。刚开始我写的是`v1`底部的 constant值20.0，然后右边的值是20.0。这是因为我参照的是一个网上资料上的例子写的。运行后发现什么都不显示。后来微调`v1`底部的距离，让其变成负数，发现视图 `v1` 显示出来了，只是 `v1` 的右边并不是和其父元素右边有20pt的距离，而是溢出了父元素右边不知道多少距离。这时我尝试将 `v1` 右边的constant值也变回负数，发现显示正常了。到这里就察觉到问题的所在了。根据计算公式，在计算右边约束的时候，item(v1)的attribute的值的计算，是根据toItem(self.view)的attribute的值乘以multipler再加上constant的值。此时toItem(self.view)的attribute是`.right`，也就是self.view的右边的值。那么self.view右边的值就等于self.view的宽度了，假如self.view的宽度是200pt，那么乘以multipler的值1.0，等于200pt，再加上当时错误设定的值20pt，就是220pt了，超出`v1`父元素`self.view`的宽度了，肯定溢出了。同理，对于底部的计算也是这样。而我恰好设置的constant都是20，导致`v1`刚好从父元素底部溢出，并且溢出的距离等于给他设置的高度约束的距离，导致`v1`不可见。

这是我当时看这个公式并没有很好理解的原因。
