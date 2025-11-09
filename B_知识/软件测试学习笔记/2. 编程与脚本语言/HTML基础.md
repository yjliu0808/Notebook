### HTML基础

#### 什么是HTML？

- HTML 是用来描述网页的一种语言。
- HTML 指的是超文本标记语言 (Hyper Text Markup Language) ，HTML 不是一种编程语言，而是一种标记语言 (markup language) 。

```html
<!DOCTYPE html> <!-- 表示为html文档 -->
<html> <!-- 页面根元素,之间的文本用于描述网页 -->
<head> <!-- head元素包含了元数据,如js，css等 -->
 <meta charset="utf-8"> <!-- 声明编码 -->
 <title>我的html</title>   <!-- 文档标题 -->
</head> <body> <!-- 页面可见页面内容 -->
 <h1>Hello World!</h1> <!-- 声明标题，标签成对出现 -->
</body>
</html>
```

#### HTML标签

- HTML 标记标签通常被称为 HTML 标签 (HTML tag)
- HTML 标签是由尖括号包围的关键词，比如 <html>
- HTML 标签通常是成对出现的，比如 <a> 和 </a>
- 标签对中的第一个标签是开始标签，第二个标签是结束标签

#### HTML元素

- Html文档是由HTML元素定义的
- Html元素指的是从开始标签到结束标签的所有代码，通常和Html标签表达的是一个意思

```html
<p>This is a paragraph</p>
```

#### html元素语法

- Html元素包含了开始标签和结束标签
- 元素的内容是开始标签与结束标签之间的内容
- 大多数 HTML 元素可拥有属性

#### 基本的HTML标签

##### **文本输入框**

```html
<input type="text" value="第一个输入框"/>
```

##### 选择框

```html
<input type="checkbox"/>
```

##### 单选/复选按钮

```html
<input type="radio"/>
```

##### 按钮

```html
<input type="button"/>
```

##### 文件上传

```html
<input type="file"/>
```

##### 密码输入框

```html
<input type="password"/>
```

##### 换行

```html
<br/>
```

##### 下拉框

```html
<select><option></option></select>
```

##### 超链接

```html
<a href="http://www.baidu.com">...</a>
```

##### 图片

```html
<img src="">
```

##### 有序列表

```html
<ol>
 <li>a</li>
 <li>b</li>
 <li>c</li>
</ol>
```

##### 无序列表

```html
<ul>
 <li></li>
 <li></li>
 <li></li>
</ul>
```

##### 文本域

```html
<textarea rows="" cols=""></textarea>  
```

##### 标题标签

```html
<h1>This is a heading</h1> 
<h2>This is a heading</h2>
<h3>This is a heading</h3>
```

##### HTML段落

HTML 段落是通过 <p> 标签进行定义的

##### HTML注释

```html
<!-- 内容 -->
```

##### iframe

在一个页面内嵌另一个页面

```html
<iframe src="http://www.baidu.com" width="200" height="200"></iframe>
```

##### HTML Div

div块级元素，用于组合其他 HTML 元素的容器,常用作进行页面布局

```html
<div class="head">
    <h1>页面顶部区域</h1>
</div> <div class="left">
    <h1>页面左面区域</h1>
</div> <div class="middle">
    <h1>页面中部区域</h1>
</div> <div class="foot">
    <h1>页面底部区域</h1>
</div>
```

### **CSS** 

```html
<style>
    .head{
        background-color:blue;
        color:white;
        text-align:center;
        padding:5px;
   }
    .left{
        line-height:30px;
        background-color:#eeeeee;
        height:300px;
        width:100px;
        float:left;
        padding:5px;
   }
    .middle{
        width:350px;
        float:left;
        padding:10px;
   }
    .foot{
        background-color:blue;
        color:white;
        clear:both;
        text-align:center;
        padding:5px;
           }
</style>
```

### **JavaScript** 

#### 什么是JavaScript?

- JavaScript是可插入 HTML 页面的编程代码

- 轻量级、功能强大编程语言

- 因特网上最流行的脚本语言

#### 使用示例

脚本位置：script>与</script标签之间，body和head(推荐)中

```html
<script>alert("Hello World")</script>
```

### HTML DOM

- HTML DOM（Document Object Model，文档对象模型）

- DOM是用于访问 HTML 元素的正式 W3C 标准

- 当网页被加载时，浏览器会创建页面的文档对象模型

- 通过 HTML DOM，可以使用JavaScript 访问 HTML文档的所有元素

- HTML DOM（Document Object Model，文档对象模型）

  <div align="left"> <img src="pics/HTMLDOM.png" width="800"/> </div><br>

通过可编程的对象模型，JavaScript 可以

1. 改变页面HTML元素

2. 改变页面HTML元素属性

3. 对页面中的事件做出反应

#### window

- 表示浏览器中打开的窗口
- JavaScript层级中的顶层对象
- window是document的父节点

#### document

- 代表窗口中显示的当前文档（页面）
- 通过document节点可以遍历到文档里的所有子节点查找HTML元素

示例：

```html
<html>
 <head>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 </head>
 <body>
 <input type="text" id="test1" value="1"/>
 <br>
 <input type="text" id="test2" value="2"/>
 <br>
 <input type="text" id="test3" value="3"/>
 <br>
 <input type="text" id="test4" value="4"/>
 <br>
 <input type="text" id="test5" value="5"/>
 <br>
 <input type="text" id="test6" value="6"/>
 <br>
 </body>
</html>
```

用document文档对象来定位HTML 元素的几种常见方式（注意一般找元素都是在窗口window加载完成后）

- 通过 id 属性找到HTML元素，id属性是唯一的，不可重复

```javascript
var element = document.getElementById("test");
```

通过 tag (标签名)找到HTML元素

```javascript
var element = document.getElementsByTagName("p");	
```

通过 class (类名)找到HTML元素，相同的class具有相同的CSS样式

```javascript
var eleArr = document.getElementsByClassName("test");
```

操作HTML元素

获取元素的属性

方式：元素.属性

获取id为test元素的value属性值：

```javascript
var value = document.getElementById("test").value;
```

设置id为test元素的value属性值为"测试"：

document.getElementById("test").value="测试";

其他属性取值、赋值方式也是一样

#### HTML DOM事件

##### onload()

当网页已加载完成时触发此事件

```javascript
window.onload = function(){
 alert("page is loaded");
}
```

##### onblur()

当元素失去焦点时触发此事件

```javascript
window.onload = function(){
 document.getElementById("test1").onblur = function(){
 alert(this.value);
 } }
```

##### onfocus()

当元素聚焦时触发此事件

```javascript
window.onload = function(){
 document.getElementById("test2").onfocus = function(){
 this.value = ‘22222’;
 } }
```

##### onchange()

当元素的value值改变时触发此事件

```javascript
window.onload = function(){
 document.getElementById("test3").onchange = function(){
 alert(this.value);
 } }
```

##### onclick()

单击触发

```javascript
window.onload = function(){
 document.getElementById("test4").onclick = function(){
 alert("test4被点击了");
 } }
```

##### ondblclick()

双击触发 

```
window.onload = function(){
 document.getElementById("test5").ondblclick= function(){
 alert("test5被双击了");
 } }
```

##### onmouseover()

当鼠标移动到某元素上时触发

```javascript
window.onload = function(){
 document.getElementById("test6").onmouseover = function(){
 alert("鼠标移上来了");
 } }
```

- html页面基本组成-元素
- 常见的标签名-input、a、iframe、img、。。。。
- CSS作用-装修
- JavaScript作用:编程语言，用在网页中
- DOM:访问/操作Html元素，提供了很多API
- DOM中查找元素的API getElmentById 、 getElementsByTagName 、getElementsByClassName
- DOM事件、窗口加载结束、元素得到焦点/失去焦点...