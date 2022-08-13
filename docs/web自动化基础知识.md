



## Selenium

### 1.Selenium介绍

- 用于Web应用程序测试的工具，Selenium是开源并且免费的，覆盖IE、Chrome、FireFox、Safari等主流浏览器，通过在不同浏览器中运行自动化测试。支持Java、Python、Net、Perl等编程语言进行自动化测试脚本编写。
- 官网地址：https://selenium.dev/

### 2.Selenium家族

- Selenium IDE，是Firefox/Chrome浏览器的扩展插件，支持用户录制和回放测试
- Selenium WebDriver，提供了各种语言环境的API来支持更多控制权和编写符合标准软件开发实践的应用程序。
- SeleniumGrid，分布式自动化工具，可以在多个测试环境中以并发的方式执行测试脚本，实现测试脚本的并发执行，缩短大量的测试脚本的执行时间

### 3.Selenium IDE

- 官网下载插件后本地安装 http://www.seleniumhq.org/download/

- Selenium IDE录制脚本:工具栏 -> Selenium IDE直接点击菜单栏Selenium 图标

- Selenium IDE局限性
  1. 只能支持Firefox/Chrome浏览器
  2. 录制的脚本稳定性不够
  3. 线性脚本，无法处理复杂的逻辑

### 4.Selenium WebDriver

Selenium WebDriver环境搭建

step1：创建Maven项目

step2：引入selenium框架/依赖

```xml
<dependency>
 <groupId>org.seleniumhq.selenium</groupId>
 <artifactId>selenium-java</artifactId>
 <version>3.141.59</version>
</dependency>
```

第一个web自动化脚本

```java
//1.设置Google浏览器的本地路径
System.setProperty("webdriver.chrome.bin", "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe");
//2.设置浏览器器驱动 (浏览器版本Google Chrome :Version 103.0.5060.134和驱动版本ChromeDriver: 103.0.5060.134)
System.setProperty("webdriver.chrome.driver", "src\\main\\resources\\chromedriver.exe");
//3.打开浏览器实例化ChromeDriver对象即可
ChromeDriver chromeDriver = new ChromeDriver();
chromeDriver.get("http://www.baidu.com");
```

Selenium WebDriver原理

- 启动driver驱动，客户端根据json wire protocol协议可以通过不同语言向driver发起请求（比如Java、python等）。驱动解析请求，并在浏览器上执行相应的操作，并把执行结果返回给客户端。

### 附:WebDriver环境问题整理

#### 1. chrome浏览器驱动路径

使用Chrome做测试时，报了如下错误:

```
The path to the driver executable must be set by the webdirver.chrome.driver system properity
```

设置Chrome驱动文件的路径

```java
System.setProperty("webdriver.chrome.driver", "xxx");
```

#### 2.Chrome与ChromeDriver

版本对照说明（Chrome V70以下）

ChromeDriver版本   支持的Chrome版本

v2.41   v67-69

v2.40   v66-68

v2.39   v66-68

v2.38   v65-67

v2.37   v64-66

v2.36   v65-67

v2.35   v62-64

v2.34   v61-63

v2.33   v60-62

v2.32   v59-61

v2.31   v58-60

v2.30   v58-60

v2.29   v56-58

Chrome V70以上按照版本对应即可

Please see https://chromedriver.chromium.org/security-considerations 

#### 3.chrome浏览器各版本下载 

http://www.chromedownloads.net/chrome64win/

4.ChromeDriver驱动镜像网址

http://chromedriver.storage.googleapis.com/index.html

官网地址：

https://chromedriver.chromium.org/security-considerations

Firefox

Firefox路径问题

firefox火狐浏览器去完成自动化测试时，代码报了如下错误：

> Cannot find firefox binary in PATH. mark sure firefox is installed

**错误原因：**

firefox安装在其它路径，不是默认的安装路径

**解决办法：**

指定firefox可执行文件路径：webdriver.firefox.bin

代码设置：

```java
System.setProperty("webdriver.firefox.bin", "D:\\Program Files\\Mozilla
Firefox\\firefox.exe");
```

#### 4.selenium 3.x Firefox驱动问题

使用selenium3.x+firefox火狐浏览器去完成自动化测试时，代码报了如下错误：

The path to the driver executable must be set by the webdriver.gecko.driver system properity

**错误原因：**

缺少火狐浏览器驱动包。如果selenium版本是3.x的，需要使用驱动包

**解决办法：**

往项目中添加火狐驱动包，并加载驱动的配置。至于该驱动版本适配的浏览器和selenium版本在驱动的

change log里有说明(如：使用selenium 3.5.1+firefox 56)

代码设置：

```
System.setProperty("webdriver.gecko.driver", "src/test/resources/geckodriver.exe");
```

#### 5.Firefox与geckodriver对应版本说明

**geckodriver**版本Firefox版本

0.15 v 48+

0.16 v 52

0.17 v 52

0.18 v 53

Change Log https://github.com/mozilla/geckodriver/blob/release/CHANGES.md

#### 6.Firefox各版本 

http://ftp.mozilla.org/pub/firefox/releases/

Firefox驱动镜像网址 https://npm.taobao.org/mirrors/geckodriver/

建议大家使用57版本的Firefox

**InternetExplorer**

IE浏览器的驱动跟着Selenium版本走即可，比如当前项目使用的Selenium是V3.141.59，那么去

Selenium的镜像网址下载对应版本的IEDriverServer驱动即可（建议使用32位的）

https://npm.taobao.org/mirrors/selenium

#### 7.IE浏览器驱动问题

使用IE浏览器去完成自动化测试时，代码报了如下错误：

The path to the driver executable must be set by the webdriver.ie.driver system property

**错误总结：**

缺少IE浏览器驱动包

**解决办法：**	

往项目中添加IE驱动包，并加载驱动的配置。

```java
System.setProperty("webdriver.ie.driver", "src/test/resources/IEDriverServer.exe");
```

下载地址 http://www.seleniumhq.org/download/

IE驱动版本与Selenium版本保持相同即可

http://selenium-release.storage.googleapis.com/index.html

#### 8.IE浏览器保护模式问题

使用IE浏览器去完成自动化测试时，代码报了如下错误：

Protected Mode Settings are not the same for all zones

解决方法1：

浏览器设置（但是换一台电脑就不适用了）

打开IE浏览器->工具->安全->全部勾选启用保护模式

解决方法2：

忽略浏览器保护模式的设置

InternetExplorerDriver.INTRODUCE_FLAKINESS_BY_IGNORING_SECURITY_DOMAINS

代码：

```java
//取消IE安全设置（忽略IE的Protected Mode的设置）
DesiredCapabilities capabilities = new DesiredCapabilities();
capabilities.setCapability(InternetExplorerDriver.INTRODUCE_FLAKINESS_BY_IGNORING_SEC
URITY_DOMAINS, true);
```

3. **IE浏览器缩放设置**

使用IE浏览器去完成自动化测试时，代码报了如下错误：

Browser zoom level was set to 125%.It should be set to 100%

**错误总结：**

浏览器缩放级别设置不对导致的(点工具栏页面->缩放设置)

**解决办法：**

忽略此设置：InternetExplorerDriver.IGNORE_ZOOM_SETTING

代码：

```java
DesiredCapabilities capabilities = new DesiredCapabilities();
capabilities.setCapability(InternetExplorerDriver.IGNORE_ZOOM_SETTING, true);
```

**4. IE浏览器window丢失问题**

使用IE浏览器去完成自动化测试时，代码报了如下错误：

unable to find element with id -- kw

**错误总结：**

不是因为没有设置等待时间，而是因为之前的window对象已经丢失

**解决办法：**

最快的解决办法是直接指定一个初始化页面

InternetExplorerDriver.INITIAL_BROWSER_URL

代码：

```java
DesiredCapabilities capabilities = new DesiredCapabilities();
capabilities.setCapability(InternetExplorerDriver.INITIAL_BROWSER_URL,
"http://www.baidu.com");
```



## 一、web自动化基础

### 1.元素定位

#### 6种基础元素定位

**By.id**

根据id来获取元素，返回单个元素，id值一般是唯一的

**By.name**

根据元素的name属性来获取元素，可能会返回元素集合

**By.tagName**

根据元素的标签名来获取元素，可能会返回元素集合

**By.className**

根据元素的样式class值来获取元素，可能返回元素集合

**By.linkText**

根据超链接的完整文本值来获取元素

**By.partialLinkText**

根据超链接的部分文本值来获取元素

```java
//第1部分：基础元素定位
//打开浏览器
        WebDriver webDriver =CommonUtils.openBrowser("chrome");
        webDriver.get("https://cn.bing.com/");
        // <input id="sb_form_q" class="sb_form_q" name="q"> 
        //1.(By.id )根据id来获取元素，返回单个元素，id值一般是唯一的
        WebElement webElement1 = webDriver.findElement(By.id("sb_form_q"));
        webElement1.sendKeys("测试通过ID定位搜索输入框的元素");
        //2.(By.name )根据元素的name属性来获取元素，可能会返回元素集合
        WebElement webElement2 = webDriver.findElement(By.name("q"));
        webElement2.sendKeys("---追加测试内容");
        //3.(By.tagName)根据元素的标签名来获取元素，可能会返回元素集合
        //findElement 默认获取第一个input的值
        WebElement webElement3 = webDriver.findElement(By.tagName("input"));
        webElement3.sendKeys("---追加3");
        //findElements,获取元素集合
        List<WebElement> webElementList1 = webDriver.findElements(By.tagName("input"));
        System.out.println("获取input元素个数:"+webElementList1.size());
        //4.(By.className) 根据元素的样式class值来获取元素，可能返回元素集合
        //className 不支持复核类名，有空格的不支持 。sb_form hassbi hasmic
        List<WebElement> webElementList2 =webDriver.findElements(By.className("sb_form hassbi hasmic"));//不支持找到复合类名
        List<WebElement> webElementList3 =webDriver.findElements(By.className("sb_form"));
        System.out.println("获取类名sb_form的个数:"+webElementList3.size());
        //5.(By.linkText) 根据超链接的完整文本值来获取元素
        webDriver.findElement(By.linkText("图片")).click();
        //6.(By.partialLinkText) 根据超链接的部分文本值来获取元素
        webDriver.findElement(By.partialLinkText("图")).click();

```



#### cssSelector元素定位

**根据tagName**

```java
By.cssSelector("input");
```

**根据ID**

```java
By.cssSelector("input#id"); //使用html标签拼上#id
By.cssSelector("#id"); //仅使用#id
```

根据className(样式名 )，.class形式

```java
By.cssSelector(".className");
By.cssSelector("input.className"); //标签拼上样式
```

根据元素属性,属性名=属性值,id,class,等都可写成这种形式

```java
By.cssSelector("标签名[属性名='属性值']");
如：By.cssSelector("input[name='xxx']")
```

单属性

```java
By.cssSelector("标签名[属性名='属性值']");
```

多属性

```java
By.cssSelector("标签名[属性1='属性值'][属性2='属性值']");
```

案例：百度首页输入框

```java
By.cssSelector("input[value='255'][autocomplete='off']");
By.cssSelector("input[autocomplete='off']");
```

```java
//第2部分：cssSelector 样式选择器元素定位
        //findElements 返回集合   findElement返回单个元素可直接sendKeys()
        //7.根据tagName
        List<WebElement> webElementList4 = webDriver.findElements(By.cssSelector("input"));
        System.out.println("样式选择器元素定位方式，获取input元素个数:" + webElementList4.size());
        //8.根据ID 单个id
        webDriver.findElement(By.cssSelector("#sb_form_q")).sendKeys("-- 测试");
        //8.根据ID 使用html标签tagName拼上#id
        //<div id="est_cn" class="est_common est_selected">国内版</div>
        webDriver.findElement(By.cssSelector("div#est_en")).click();
        webDriver.findElement(By.cssSelector("input#sb_form_q")).sendKeys("百度");
        //9.根据className(样式名 )，.class形式  支持复合和单个类名
        //<label for="sb_form_go" class="search icon tooltip" id="search_icon" aria-label="搜索网页">
        webDriver.findElement(By.cssSelector(".search")).click();
        //10.单属性选择 -支持元素的全部属性（不能支持文本）
        webDriver.get("https://www.baidu.com/");
        webDriver.findElement(By.cssSelector("input[maxlength='255']")).sendKeys("测试同学");
        //10.多属性选择 --同时支持多个属性定位
        webDriver.findElement(By.cssSelector("input[name='wd'][maxlength='255'][autocomplete='off']")).sendKeys("===追加内容");

```



#### xpath元素定位

- xpath其实就是一个path（路径），一个描述页面元素位置信息的路径，相当于元素的坐标
- xpath基于XML文档树状结构，是XML路径语言，用来查询xml文档中的节点
- 既可以用于XML，也可以用于HTML

#### xpath绝对定位

- 从根开始找-- /(根目录)
- 绝对路径以单/号表示，而且是让解析引擎从文档的根节点开始解析，也就是html这个节点下开始解析
- 路径解释：html--> body--> 第二个div--> div--> ...

**缺点**

一旦页面结构发生变化（比如重新设计时，路径少了两节），该路径也随之失效，必须重新写

#### xpath相对定位

- 只要不是/开始的，就是相对路径
- 相对路径则以//表示，则表示让xpath引擎从文档的任意符合的元素节点开始进行解析

路径解释：

- **//** 匹配指定节点，不考虑它们位置（/则表示绝对路径，从根下开始）
- \* 通配符，匹配任意元素节点。
- **@**选取属性
- **[]** 属性判断条件表达式

相对定位优点：灵活，方便，耦合性低

通过元素名定位

```java
//input 获取页面所有input元素
```

通过元素名+索引定位

```java
//form/div[1]/input 获取手机号输入框
```

使用元素名+属性

```java
//*[@name='phone'] 获取手机号输入框
```

使用元素(html元素-->标签)名+包含部分属性值

```
//*[contains(@name,'one')] 获取手机号输入框
```

使用元素名+元素的文本内容

```java
//*[text()='免费注册'] 获取免费注册超链接，注意空格
```

使用元素名+包含元素的部分文本内容

```java
//*[contains(text(),'免费')] 获取免费注册超链接
```

```java
//第三部分：
        //打开浏览器
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("https://baidu.com/");
        //1.xpath定位
        //xpath绝对定位
        //   <a href="http://news.baidu.com" target="_blank" class="mnav c-font-normal c-color-t">新闻</a>
        //webDriver.findElement(By.xpath("html/body/div[1]/div[1]/div[3]/a")).click();
        //2.xpath相对定位 -通过元素名定位  属性选择@后面跟着的是属性名
        //System.out.println("xpath相对定位 -通过元素名定位:"+webDriver.findElements(By.xpath("//input")).size());
        //xpath相对定位 使用元素名+属性
        //webDriver.findElement(By.xpath("//*[@name='wd']")).sendKeys("属性选择定位元素");
        //使用元素(html元素-->标签)名+包含部分属性值
        //webDriver.findElement(By.xpath("//*[contains(@name,'wd')]")).sendKeys("=====追加使用元素名+包含部分属性值 ");
        //xpath相对定位: 文本选择  text()文本函数  文本精确匹配用的
       /* webDriver.findElement(By.xpath("//*[@id=\"su\"]")).click();
        webDriver.get("https://baidu.com/");*/
        webDriver.findElement(By.xpath("//*[text()='新闻']")).click();
```

#### xpath轴定位

- 当某个元素的各个属性及其组合都不足以定位时，那么可以利用其兄弟节点或者父节点等各种可以定位的元素进行定位。

轴名称 及释义

- ancestor 选取当前节点的所有祖先节点（包括父节点）
- parent    选取当前节点的父节点
- preceding  选取当前节点之前的所有节点
- preceding-sibling 选取当前节点之前的所有兄弟节点
- following  选取当前节点之后的所有节点
- following-sibling  选取当前节点之后的所有兄弟节点

使用语法：

/轴名称:：节点名称[@属性=值]

```java
//div/table//td//preceding::td
```

**总结** 

- 六种基础元素定位 **id**、**name**、tagName、**className**、linkText、**partialLinkText**
- cssSelector 样式定位器，可以支持id、tagName、className基本定位，还可以支持单属性/多属性定位
- xpath绝对定位-绝对不推荐，难以维护
- xpath相对定位，支持属性选择、文本选择 同时支持属性和文本混合选择（and拼接）
- xpath模糊匹配： contains()函数 ，两个参数，第一个参数可以为属性选择也可以为文本选择，第二个参数就是为对应的属性值/文本值
- 轴定位：根据相邻的元素来辅助定位 三个常用的轴名称：parent（找爸爸）、preceding-sibling（找哥哥）、following-sibling（找弟弟）



#### 如何定位不可见元素

<video id="video" controls="" preload="none"> <source id="mp4" src="vodeos/test.wmv" type="video/mp4"> </video>



### 2.元素WebElement常见API

#### **click()**

触发当前元素的点击事件

#### **clear()**

清空内容

#### **sendKeys(...)** 

往文本框一类元素中写入内容

```java
element.sendKeys("测试");//输入内容”测试”
```

#### element按键操作

```java
element.sendKeys(Keys.CONTROL,"a");//ctrl+a 全选
element.sendKeys(Keys.CONTROL,"x");//ctrl+x 剪切
element.sendKeys(Keys.CONTROL,"c");//ctrl+c 复制
element.sendKeys(Keys.CONTROL,"v");//ctrl+v 粘贴
element.sendKeys(Keys.ENTER);//回车
element.sendKeys(Keys.BACK_SPACE);//删除
element.sendKeys(Keys.SPACE);//空格键
```

#### **getTagName()**

获取元素的的标签名

#### **getAttribute(属性名)**

根据属性名获取元素属性值

#### **getText()**

获取当前元素的文本值

#### **isDisplayed()**

查看元素是否显示

```java
WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("http://www.baidu.com");
        WebElement webElement = webDriver.findElement(By.id("kw"));
        webElement.sendKeys("测试同学1");
        //休眠延时等待
        Thread.sleep(3000);
        //clear 清楚文本输入框内容
        webElement.clear();
        //element.sendKeys按键操作
        webElement.sendKeys("测试同学2");
        Thread.sleep(2000);
        webElement.sendKeys(Keys.CONTROL, "a");//ctrl+a 全选
        Thread.sleep(2000);
        webElement.sendKeys(Keys.CONTROL, "x");//ctrl+x 剪切
        Thread.sleep(2000);
        webElement.sendKeys(Keys.CONTROL, "v");//ctrl+v 粘贴
        Thread.sleep(2000);
        webElement.sendKeys(Keys.CONTROL, "a");//ctrl+a 全选
        Thread.sleep(2000);
        webElement.sendKeys(Keys.BACK_SPACE);//删除
        Thread.sleep(2000);
        webElement.sendKeys("测试同学3");
        Thread.sleep(2000);
        webElement.sendKeys(Keys.CONTROL, "a");//ctrl+a 全选
        Thread.sleep(2000);
        webElement.sendKeys(Keys.CONTROL, "c");//ctrl+c 复制
        Thread.sleep(2000);
        webElement.sendKeys(Keys.CONTROL, "v");//ctrl+v 粘贴
        Thread.sleep(2000);
        //webElement.sendKeys(Keys.ENTER);//回车
        Thread.sleep(2000);
        //getTagName  获取元素标签名
        //getAttribute(属性名)  根据属性名获取元素属性值
        System.out.println("getTagName获取元素标签名:" + webElement.getTagName());
        System.out.println("getAttribute(属性名)根据属性名value获取元素属性值:" + webElement.getAttribute("value"));
        //getText() 获取元素文本值
        System.out.println("getText()获取元素文本值:" + webElement.getText());
        //isDisplayed  判断元素是否显示 //可见输出true
        System.out.println("判断元素是否显示:" + webElement.isDisplayed());
        /*
            (元素不可见会报错提示：element is not attached to the page document )
            System.out.println("元素不可交互:"+webElement.isDisplayed());
         **/
```



### 3.**WebDriver常用API** 

#### **get(String url)**

访问指定url页面

```java
driver.get(String url);
```

#### **getCurrentUrl()**

获取当前页面的url地址

```java
driver.getCurrentUrl();
```

#### **getTitle()**

获取当前页面的标题

```java
driver.getTitle();
```

#### **getPageSource()**

获取当前页面源代码

```java
driver.getPageSource();
```

#### **quit()**

关闭驱动对象以及所有相关的窗口

```java
driver.quit();
```

#### **close()**

关闭当前窗口

```java
driver.close();
```

```java
 WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("http://www.baidu.com");
        //1.getCurrentUrl()  获取当前页面的url
        System.out.println("获取当前页面的url:" + webDriver.getCurrentUrl());
        //2.getTitle() 获取当前页面的标题
        System.out.println("获取当前页面的标题" + webDriver.getTitle());
        //3.getPageSource() 获取当前页面源代码
         System.out.println(webDriver.getPageSource());
         //4.close() 关闭当前窗口
        webDriver.findElement(By.partialLinkText("新闻")).click();
        Thread.sleep(3000);
        webDriver.close();
        //4.quit() 关闭所有的窗口
        Thread.sleep(3000);
        webDriver.quit();
```



### 4.**navigate对象-- 导航栏**

关于浏览器的基本功能操作，大部分都是由navigate对象提供的，如完成浏览器回退或者导航到指定url

页面等操作

```java
       //导航使用（包括浏览器刷新、前进、后退）
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("http://www.baidu.com");
        //获取navigate对象
        WebDriver.Navigation navigation = webDriver.navigate();
        //访问指定的url地址
        Thread.sleep(2000);
        navigation.to("https://cn.bing.com/");
        Thread.sleep(2000);
        //刷新当前页面
        navigation.refresh();
        Thread.sleep(2000);
        //浏览器回退操作
        navigation.back();
        Thread.sleep(2000);
        //浏览器前进操作
        navigation.forward();
```

### **5.window**基本操作

关于窗口的设置，基本都是由window对象提供的

```java
 //windows相关操作
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("http://www.baidu.com");
        //1.获取window对象
        WebDriver.Window window = webDriver.manage().window();
        //2.浏览器最大化 maximize 可避免很多问题（比如元素不可见）
        Thread.sleep(2000);
        window.maximize();
        //3.浏览器全屏
        Thread.sleep(2000);
        window.fullscreen();
        //4.获取到窗口位置  -以最左上角的点为原点，从左到右X轴，从上到下Y轴
        System.out.println("从左到右X轴:"+window.getPosition().getX());
        System.out.println("从上到下Y轴:"+window.getPosition().getY());
        //5.获取到窗口的大小
        System.out.println("窗口Width:"+window.getSize().getWidth());
        System.out.println("窗口Height:"+window.getSize().getHeight());
        //6.设置窗口的位置
        Thread.sleep(2000);
        Point point = new Point(100,100);
        window.setPosition(point);
        //7.设置窗口的大小
        Thread.sleep(2000);
        Dimension dimension = new Dimension(30,80);
        window.setSize(dimension);
```

### 6.Element三大等待

#### 硬性等待

```
Thread.sleep(long millis);
```

优点：使用简单

缺点：容易造成时间浪费

#### **隐式等待**

在设置的超时时间范围内不断查找元素，直到找到元素或者超时

如：设置等待时间为5秒，在第3秒找到元素，不再继续等待

设置方式

```java
driver.manage.timeouts().implicitlyWait(long time, TimeUnit unit);
```

优点：相对灵活

缺点：

设置是针对全局的，在WebDriver实例整个生命周期有效，但并不是所有的元素都需要等待。

不能适用条件更复杂的情况，如：元素可点击、元素可见

#### **显式等待**

显式等待通常是我们自定义的一段代码，用来等待某个条件发生后再继续执行后续代码（如找到元素、

元素可点击、元素已显示等）

使用方式：

```java
WebDriverWait wait = new WebDriverWait();
WebElement element = wait.until(expectCondition);
```

优点:

每隔一段时间扫描一次页面，检查元素是否满足等待结果条件，比如查找元素，则检查元素是否存在，

不存在则继续等待，直到找到或超时。

该方式不是全局设置，因此特定需要等待的元素可以这样处理，推荐优先使用这一种方法。

**等待条件**

presenceOfElementLocated 页面元素在页面中存在

visibilityOfElementLocated 页面元素在页面存在并且可见

elementToBeClickable 页面元素是否在页面上可用和可被单击

```java
WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("https://cn.bing.com");
        WebElement webElement = webDriver.findElement(By.name("q"));
        //1.硬性等待:Thread.sleep(long millis)
        Thread.sleep(1000);
        webElement.sendKeys("腾讯云");
        webElement.sendKeys(Keys.ENTER);//回车
        //2.设置全局隐式等待 //在设置的超时时间范围内不断查找元素，直到找到元素或者超时
        //隐式等待生效：后面findElement找元素的话就会有隐式等待的效果
        //隐式等待只会针对于元素存在的情况（在dom中存在），可见或者不可见均适用
        webDriver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS); //找元素之前设置
        WebElement webElement2 = webDriver.findElement(By.xpath("//*[@id=\"tile_link_cn\"]/strong[1]"));
        webElement2.click();
        //3.显示等待的方式
        //3.1创建WebDriverWait对象   超时时间默认就是为秒
        WebDriverWait webDriverWait = new WebDriverWait(webDriver,10);
        //3.2通过该对象所提供的方法 until  -->直到某个条件满足时为止
        //内置条件1 : presenceOfElementLocated  --> 元素在当前dom中存在  跟隐式等待的效果差不多
        //visibilityOfElementLocated  --> 元素可见的  肉眼可见 输入框/获取到元素信息
        WebElement webElement3 =  webDriverWait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"b_results\"]/li[2]/div[1]/h2/a")));
        webElement3.click();
        //内置条件2 :elementToBeClickable  -->元素可被点击 按钮/超链接
        WebElement webElement4 = webDriverWait. until
                (ExpectedConditions.elementToBeClickable(By.xpath("//*[@id=\"b-scopeListItem-images\"]/a")));
        webElement4.click();
        //隐式等待 VS 显示等待
        //1.作用域范围:隐式->全局生效   显示->针对某一个元素
        // 2.条件范围:隐式->元素存在    显示->存在、可见、可被点击
        //3.超时:    隐式->秒/分钟/天  显示->默认为秒
```



### 7.(弹框及内嵌页面及window)三大切换场景

#### 1.**切换**Alert

得到alert框

```
Alert alert = driver.switchTo().alert();
```

常用api:

```
alert.getText(); //获取警告框中的提示信息
alert.accept(); //点击确认按钮
alert.dismiss(); //取消
```

```java
 //1.Alert弹窗的处理
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("D:\\Repository\\Git_AthenaRep\\PrivateOthenrs\\Code\\web_auto_athena_vsion\\web_auto_athena_v1\\src\\main\\resources\\login.html");
        webDriver.findElement(By.id("user")).sendKeys("athena");
        webDriver.findElement(By.id("pwd")).sendKeys("123456");
        webDriver.findElement(By.xpath("//*[@id=\"login\"]")).click();
        //得到alert框
        Alert alert = webDriver.switchTo().alert();
        System.out.println("获取警告框中的提示信息:" + alert.getText()); //获取警告框中的提示信息
        Thread.sleep(2000);
        alert.accept(); //点击确认按钮
        Thread.sleep(2000);
        alert.accept(); //点击确认按钮
        Thread.sleep(2000);
        //alert.dismiss(); //取消

```



#### **2.切换**Iframe

当想要定位iframe中的元素时，由于driver的焦点还停留在原页面，我们在iframe新的页面上定位元素

时，自然会产生错误，所以我们需要将driver的焦点切换到iframe页面中。

切换方式：

1. iframe的索引，在页面中的位置

```
driver.switchTo().frame(index);
```

2. iframe的id

```
driver.switchTo().frame(nameOrId);
```

3. iframe WebElement

```
driver.switchTo().frame(WebElement);
```

4. 跳转到父级iframe中，如果是顶级iframe，不会有任何变化。

```
driver.switchTo().parentFrame()
```

5. 回到默认内容页面(否则会找不到元素)

```
driver.switchTo().defaultContent()
```

```
  //2.iframe切换
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("https://cloud.tencent.com/voc/");
        WebDriver.Window window = webDriver.manage().window();
        window.maximize();//浏览器最大化
        //点击首页登录按钮
        WebElement webElement = webDriver.findElement(By.xpath("//*[@id=\"navigationBar\"]/div/div[2]/div[2]/a[1]"));
        webElement.click();
        Thread.sleep(3000);
        //点击扫码登录页面 qq方式登录
        WebElement webElement1= webDriver.findElement(By.xpath("//*[@id=\"loginBox\"]/div/div/div[4]/div[2]/div[2]/a/span"));
        webElement1.click();
        Thread.sleep(3000);
        ////此元素在iframe中
        //1.iframe切换:通过index索引来切换  索引从0开始
        //webDriver.switchTo().frame(0);
        //2.iframe切换: 根据id来切换  <iframe frameborder="0" width="407" height="331" id="ptlogin_iframe" name="ptlogin_iframe"></iframe>
        WebElement element = webDriver.findElement(By.id("ptlogin_iframe")); //iframe的id属性得到元素
        webDriver.switchTo().frame(element );
        //点击qq登录页面的 账号密码方式登录
        WebElement webElement2= webDriver.findElement(By.xpath("//*[@id=\"switcher_plogin\"]"));
        webElement2.click();
        Thread.sleep(3000);
        //输入账号
        WebElement webElement3= webDriver.findElement(By.xpath("//*[@id=\"u\"]"));
        webElement3.clear();
        webElement3.sendKeys("2761104162");
        //输入密码
        WebElement webElement4= webDriver.findElement(By.xpath("//*[@id=\"p\"]"));
        webElement4.clear();
        webElement4.sendKeys("112233lyj");
        Thread.sleep(3000);
        webDriver.findElement(By.xpath("//*[@id=\"login_button\"]")).click();
        Thread.sleep(3000);
        webDriver.findElement(By.xpath("//*[@id=\"newVcodeArea\"]/div[1]/div/div[1]/a")).click();
        //3.iframe切换:一级一级回到上一层页面中
        webDriver.switchTo().parentFrame();
        //回退到首页
        WebDriver.Navigation navigation = webDriver.navigate();
        navigation.back();
        //首页登录
         webDriver.findElement(By.xpath("//*[@id=\"navigationBar\"]/div/div[2]/div[2]/a[1]")).click();
```



#### **3.切换**Window窗口

当我们点击了 a 标签元素时，会触发打开链接页面的事件，有两种情形：

1. 在当前窗口加载新页面内容

2. 新建一个窗口加载新页面内容，这种情况： a 标签有 target="_blank" 时触发
3. 当发生第2种情况时，同iframe类似，我们需要切换窗口

切换方式：传入要操作窗口的handle句柄 -- 窗口的身份标识 、每一个窗口的句柄都不同，句柄是不会重复（）

```
driver.switchTo.window(nameOrHandle);
```

如何获取到窗口的句柄

```
driver.getWindowHandle();//获取当前操作窗口的句柄
driver.getWindowHandles();//获取测试时打开的所有窗口句柄
```

```
    //window窗口切换
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("http://www.baidu.com");
        System.out.println("获取当前操作窗口的句柄1："+webDriver.getWindowHandle());
        Thread.sleep(1000);
        //点击了这个链接，查看窗口的句柄  //4个句柄结果值一样
        webDriver.findElement(By.linkText("hao123")).click();
        System.out.println("获取当前操作窗口的句柄2："+webDriver.getWindowHandle());
        Thread.sleep(1000);
        webDriver.findElement(By.linkText("新闻")).click();
        System.out.println("获取当前操作窗口的句柄3："+webDriver.getWindowHandle());
        Thread.sleep(1000);
        webDriver.findElement(By.linkText("贴吧")).click();
        System.out.println("获取当前操作窗口的句柄4："+webDriver.getWindowHandle());
        Thread.sleep(2000);
        //两个窗口的切换 (需要得到每个窗口的句柄)
         String beforeHandle = webDriver.getWindowHandle();
        System.out.println("第一个窗口的句柄："+beforeHandle);
        //获取到所有的窗口句柄，把第一个给剔除掉，得到的就是第2个窗口的句柄 //set集合无序的不可重复的
        Set<String> handles = webDriver.getWindowHandles();
        String secondHandle = "";
        for(String handle : handles){
            if(handle.equals(beforeHandle)){
                //若一样就继续循环，直到不一样跳出循环，赋值给第2个窗口的句柄
               continue;
            }
             secondHandle = handle;
        }
        System.out.println("第二个窗口的句柄："+secondHandle);
        //1.个窗口切换窗口
        webDriver.switchTo().window(secondHandle);
        webDriver.findElement(By.xpath("//a[text()='腾讯']")).click();
        //2.多个窗口的切换（同时有两个新的窗口以上）
        Set<String> handles2= webDriver.getWindowHandles();
        for(String handle : handles2){
            // --根据窗口的信息（title、url）找到对应窗口的句柄
            if(webDriver.getCurrentUrl().equals("http://news.baidu.com/")){
                //driver现在是在正确的窗口中-- 同样说明现在的handle也是正确，我们不需要再切换了
            }else{
                //切换handle句柄
                webDriver.switchTo().window(handle);
            }
        }
        webDriver.findElement(By.xpath("//*[@id=\"ww\"]")).sendKeys("就是切换到新闻的窗口");
        //NoSuchElementException 可能的原因
        //1、定位表达式写错了
        //2、元素没有加载出来，等待
        //3、元素在iframe中
        //4、元素在新的窗口里面
```



### 8.Select下拉选择框

如果页面元素是一个下拉框，我们可以将此web元素封装为Select对象。

```
Select select = new Select(WebElement element);
```

Select对象常用api

```
select.getOptions();//获取所有选项
select.selectByIndex(index);//根据索引选中对应的元素
select.selectByValue(value);//选择指定value值对应的选项
select.selectByVisibleText(text);//选中文本值对应的选项
```

```
 //select下拉框
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("D:\\Repository\\Git_AthenaRep\\PrivateOthenrs\\Code\\web_auto_athena_vsion\\web_auto_athena_v1\\src\\main\\resources\\web2.html");
        WebDriver.Window window = webDriver.manage().window();
        window.maximize();//浏览器最大化                //*[@id="tSelect"]/div/div[1]/div/input
        WebElement webElement = webDriver.findElement(By.xpath("/html/body/select[1]"));
        Select select = new Select(webElement);
        Thread.sleep(2000);
        //根据索引选择对应选项
        select.selectByIndex(2);
        //根据文本选择
        WebElement webElement2 = webDriver.findElement(By.xpath("/html/body/select[2]"));
        Select select2 = new Select(webElement2);
        select2.selectByVisibleText("成都");
```



### 9.鼠标操作

自动化测试时，有些元素不适合直接点击或者进行某些操作时，可以使用Selenium的Actions类来模拟

鼠标键盘操作，通过Actions对象可以发起鼠标左键、右键、移动鼠标等操作，最后使用perform方法执

行操作。

```
clickAndHold() //在特定元素上单击鼠标左键（不释放）
release() //在特定元素上释放鼠标左键
doubleClick() //在特定元素上双击鼠标左键
moveToElement() //移动鼠标指针到特定元素
contextClick() //在特定元素上右键单击
dragAndDrop() //拖拽元素
perform() //执行具体的操作,前面6个方法都是声明一个操作，只有调用perform()后才会真正执 行操作
```

Actions:

在操作一个页面元素的时候需要一连串的动作配合的时候，可以使用Actions来完成

```
actions.clickAndHold(onElement).moveToElement(toElement).release().build().perform();
```

```
 //9.鼠标操作
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("http://www.baidu.com");
        //例一:
        webDriver.manage().window().maximize();
        Thread.sleep(2000);
        //百度设置
         WebElement webElement = webDriver.findElement(By.id("s-usersetting-top"));
        Actions actions = new Actions(webDriver);
        actions.moveToElement(webElement).build().perform();
        Thread.sleep(2000);
        //例子二
        webDriver.get("http://www.treejs.cn/v3/demo/cn/exedit/drag.html");
        Thread.sleep(2000);
        //随意拖拽1-1 treeDemo_2_span
        WebElement webElement1 = webDriver.findElement(By.id("treeDemo_2_span"));
        Thread.sleep(2000);
        //随意拖拽1-2 treeDemo_3_span
        WebElement webElement2 = webDriver.findElement(By.id("treeDemo_3_span"));
        Actions actions2 = new Actions(webDriver);
        actions2.clickAndHold(webElement1).moveToElement(webElement2).release().build().perform();
```

**总结** 

- alert弹窗切换 通过Alert类来处理
- iframe切换 确认元素是否在iframe中（根据路径是否有iframe关键字），根据索引切换/根据ID切换/根据iframe元素切换, parentFrame-->回到上一级页面中，defaultContent-->回到默认的页面中
- window切换 句柄handle，多个窗口切换的时候是根据窗口title/URL来去切换对应的句柄
- select下拉框，通过Select类处理
- 鼠标操作，鼠标持续左击、右击、移动到指定元素上...，鼠标动作生效一定要记得调用build().perform()

### 10.时间控件

控件没有限制手动输入，则直接调用sendKeys方法写入时间数据

控件有限制输入，则可以执行一段JavaScript代码来改变元素的value属性值

案例：

https://www.layui.com/demo/form.html

12306时间选择框

### **11.JavaScript调用**

某些特殊情况下，使用selenium的api无法操作页面元素，可以考虑通过执行js来完成。

使用方式1-不传参：

```
JavascriptExecutor jsExecutor=(JavascriptExecutor) driver;
jsExecutor.executeScript("...");
```

使用方式2-传参：

```
WebElement element = driver.findElement(By.id("xx"));
JavascriptExecutor jsExecutor=(JavascriptExecutor) driver;
jsExecutor.executeScript("arguments[0]...",element);
```

使用场景：

设置/去除元素属性 setAttribute/removeAttribute

页面滑动

window.scrollTo(0, document.body.scrollHeight) 滚动到页面最底部

element.scrollIntoViewIfNeeded(true) 滚动到指定元素的位置

案例：

LazyLoad懒加载：https://www.wandoujia.com/top/app

### 12.文件上传

文件上传是自动化中比较麻烦棘手的部分。

第一种情况：

```
<input type="file" id="fu" value="选择文件">
```

因为上传文件会需要打开windows的文件选择窗口，而selenium是无法操作这个窗口的

解决办法：使用sendKeys写入文件的路径

```
 @Test
    public void FileCase() throws InterruptedException {
        //文件上传
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        webDriver.get("D:\\Repository\\Git_AthenaRep\\PrivateOthenrs\\Code\\web_auto_athena_vsion\\web_auto_athena_v1\\src\\main\\resources\\web2.html");
        //1.元素为input标签，并且type为file文件上传
        Thread.sleep(2000);
        webDriver.findElement(By.xpath("/html/body/input[5]")).sendKeys("D:\\Repository\\Git_AthenaRep\\PrivateOthenrs\\Code\\web_auto_athena_vsion\\web_auto_athena_v1\\src\\main\\resources\\a.jpeg");
    }
     @Test
    public void FileCase2() throws InterruptedException {
        //文件上传
        WebDriver webDriver = CommonUtils.openBrowser("chrome");
        //2.元素不为input标签
        webDriver.get("");
        webDriver.findElement(By.id("test1")).sendKeys("D:\\Repository\\Git_AthenaRep\\PrivateOthenrs\\Code\\web_auto_athena_vsion\\web_auto_athena_v1\\src\\main\\resources\\a.jpeg");
        //上传的windows窗口--点击上传按钮
        webDriver.findElement(By.id("test1")).click();
        //执行autoit转换之后的exe文件
        //1、生成runtime对象  -》Java运行时对象，有提供了执行exe文件API
        Runtime runtime = Runtime.getRuntime();
        //2、runtime的exec方法
        try {
            runtime.exec("src/test/resources/autoittest.exe");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
```

**总结** 

1、时间控件，如果手动输入时间，可以在代码里面直接调用sendKeys

2、时间控件，限制了输入，通过执行JavaScript修改属性/移除属性 （readonly）-12306

3、JavascriptExecutor执行JavaScript 不传参/传参 ，Java代码可以传参给JavaScript，提高JavaScript使用范围

4、文件上传，（1）input标签，type为file类型 直接通过sendKey写入数据 （2）不是input标签，通过第三方的工具AutoIT

5、验证码，推荐用万能验证码