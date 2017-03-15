---
type: "project"
title: "Projects"
description: "towry's projects list"
---
<style type="text/css">
.list {
	list-style: none;
	margin: 0;
	padding: 0;
}

.list > .item:after {
	display: block;
	height: 0;
	clear: both;
}

.item .item-link {
	text-decoration: none;
	font-size: 100%;
	font-weight: normal;
}
.item .item-desc {
	display: inline-block;
	white-space: normal;
	word-wrap: break-word;
	word-break: break-all;
	font-size: 90%;
	margin: 0 0 0 10px;
}

.item .cate {
	color: #89ace4;
	font-weight: bold;
}
</style>

<ul class="list">
</ul>

<script type="text/template" id="tpl">
<li class="item">
	<a href="${link}" class="item-link" target="_blank">${name}</a>
	<p class="item-desc">${desc}</p>
</li>
</script>

<script>
var ProjectList = (function () {
	return [
		{name: "webpackrails", desc: "[rails] 用于在rails使用webpack，配合`erb-loader`可以支持在js中嵌入erb代码"},
		{name: "erb-loader", desc: "[webpack] webpack loader，配合`webpackrails`这个gem使用" },
		{name: "react-best-practice", desc: "[js] 自己对React中的Flux架构的理解和实现, 可以看这个<a href=\"https://github.com/towry/react-best-practice/blob/master/scripts/fluxie.js\">fluxie.js</a>文件" },
		{name: "deps-webpack-plugin", desc: "[webpack] 用于在webpack中获取文件的依赖列表" },
		{name: "react-content-scroll", desc: "[react] 提供一个自定义滚动条，并且方便服务端的渲染(使用ssr文件)" },
		{name: "react-bridge", desc: "[react] 一个简单的组件间通信解决方案" },
		{name: "react-photo-select", desc: "[js, react] 一个图片选择组件" },
		{name: "composer-core", desc: "[react] facebook的draft.js出来以后这个就废了" },
		{name: "yt-tooltip", desc: "[angular] 一个angular directive，tooltip组件" },
		{name: "trach", desc: "[js] 一个简单的d3图表库, 用于快速画一个图表出来" },
		{name: "fscache-loader", desc: "[webpack] 用于加快webpack的编译速度，第一次编译后，可以加快至少50%" },
		{name: "greedy-snake", desc: "[js] 终端上的贪吃蛇游戏" },
		{name: "phen", desc: "[js] Promise 的一个精简实现" },
		{name: "jquery-dragify", desc: "[js] 一个jquery拖拽插件" },
		{name: "jquery-dragswitch", desc: "[js] 一个jquery插件, 用于拖拽切换元素未知" },
		{name: "blendjs", desc: "[js] 一个amd异步定义模块的简单实现" },
		{name: "cocover.js", desc: "[js] 一个神奇的jquery插件" },
		{name: "del", desc: "[c] 一个rm的替代，将文件移到Trash文件夹里而不是彻底删除，用c写的所以很快" },
		{name: "cape", desc: "[c] 一个简单语言的实现" },
		{name: "lexer", desc: "[c] 一个 lexer .." },
		{name: "n-ary-tree", desc: "[c++] 一个泛型的 k-arr tree 的c++实现，用于编译器中ast的实现支持" },
		{name: "doraemon-css", desc: "css画哆啦A梦" },
		{name: "raste-go", desc: "[golang] 一个工具，用于编译前端文件，实现css module，还未被应用" },
		{name: "zmjdc", desc: "一个php写的网站应用，帮助记单词" },
		{name: "Taste", desc: "php简单框架" },
		{name: "bin-packing", desc: "尝试使用bin-packing算法做div动态布局" },
		{name: "dotfile-cli", desc: "[rust] 一个dotfile管理工具" },
		{name: "repeatc.vim", desc: "[vim] vim 插件，方便在css中输入 --------- 注释" },
		{name: "pgtd", desc: "大学时做的小demo，Sinatra + React，好像是个todo应用吧" },
		{name: "helper.vbs", desc: "一个windows上的vbs脚本" },
	];
}).call(this);

var App = (function () {

	function render(tpl, context) {
		var fragments = tpl.split(/(\$\{\w+\})/);
		var code = '';
		var token = null;
		fragments.forEach(function (item) {
			if (/\$\{\w+\}/.test(item)) {
				// token
				var match = item.match(/\$\{(\w+)\}/);
				if (match && match.length >= 2) {
					token = match[1];
					code += context[token];
				}
			} else {
				code += String(item);
			}
		});

		return code;
	}

	function init() {
		var html = '';
		var li = '';
		var tpl = document.getElementById('tpl').innerText;
		ProjectList.forEach(function (item) {
			item.link = 'https://github.com/towry/' + item.name;
			item.desc = item.desc.replace(/`(.+)`/, function (a, b) {
				return '<code>' + b + '</code>';
			});
			item.desc = item.desc.replace(/(\[.+\])/, function (a, b) {
				return '<span class="cate">' + b + '</span>';
			});
			li = render(tpl, item);
			html += li;
		});

		var container = document.querySelector('.list');
		container.innerHTML = html;
	}

	return {
		init: init,
	}
}).call(this);

window.onload = App.init;
</script>
