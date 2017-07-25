---
title: "快速了解UICollectionView的使用"
date: "2017-07-25 09:26:16"
description: "快速了解UICollectionView的使用"
---

UICollectionView类似UITableView，但是布局更灵活。我认为这得益于其对于一些实现的分离，比如将
布局交给了UICollectionViewLayout类，数据交给了UICollectionViewDataSource类。这种分离也
也是苹果对于Delegation模式的一种应用，即我们可以将这两个类都看作是Delegation的一种，将某种控制权
交给了第二者。

除了上面说过的两个类，还有UICollectionViewLayoutAttributes, UICollectionViewController
等。这几种类都有各自的职责，如果只是钻到文档中，一个接一个的看，很容易迷失而不知所以。先列出各个
类的角色和作用，然后理清之间的关系，这样才能对这个UICollectionView有一个全面的认识。

to be continue...
