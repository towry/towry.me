---
title: "真正解决 Python BeautifulSoup 中文内容乱码问题"
date: "2015-11-28"
tags:
    - code
---

通常的解决方案是通过设定`from_encoding`参数来解决的，比如网页的编码是
`gbk`，那么可以这样设定 BeautifulSoup: `sopu = BeautifulSoup(content, from_encoding='gb18030')`。

如果上面的方面失效，那么可能不是 BeautifulSoup 的问题了。如果网页的内容是通过`requests`获取到的话，
那么这个乱码问题极有可能跟`requests`有关。看下面的代码：

```python
r = requests.get(url)
content = r.content
```

这里的 `content` 是返回的字符串内容，如果检查 `content` 的 `encoding` 属性，会发现这个属性
的值会是 `ISO-8859-1`。此时运行 `print content` 是显示的乱码。解决这个问题的方法是，
先 `gbk` 解码，然后 `utf-8` 编码字符串内容，运行 `print content.decode('gbk').decode('utf-8')`
会发现可以正常输出中文了。

问题解决! :)
