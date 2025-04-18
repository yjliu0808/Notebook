# Vue Day 01

### 一. 邂逅Vuejs

#### 1.1. 认识Vuejs

* 为什么学习Vuejs
* Vue的读音
* Vue的渐进式
* Vue的特点



#### 1.2. 安装Vue

* CDN引入
* 下载引入
* npm安装



#### 1.3. Vue的初体验

* Hello Vuejs
  * mustache -> 体验vue响应式
* Vue列表展示
  * v-for
  * 后面给数组追加元素的时候, 新的元素也可以在界面中渲染出来
* Vue计数器小案例
  * 事件监听: click -> methods

#### 1.4. Vue中的MVVM



#### 1.5. 创建Vue时, options可以放那些东西

* el:
* data:
* methods:
* 生命周期函数



### 二.插值语法

* mustache语法
* v-once
* v-html
* v-text
* v-pre: {{}}
* v-cloak: 斗篷



### 三. v-bind

#### 3.1. v-bind绑定基本属性

* v-bind:sr
* :href


#### 3.2. v-bind动态绑定class

* 对象语法: 作业 :class='{类名: boolean}'
* 数组语法: 

#### 3.3. v-bind动态绑定style

* 对象语法:
* 数组语法:



### 四. 计算属性

* 案例一: firstName+lastName
* 案例二: books -> price



### 一. 计算属性

#### 1.1. 计算属性的本质

* fullname: {set(), get()}

#### 1.2. 计算属性和methods对比

* 计算属性在多次使用时, 只会调用一次.
* 它是由缓存的



### 二. 事件监听

#### 2.1. 事件监听基本使用



#### 2.2. 参数问题

* btnClick
* btnClick(event)
* btnClick(abc, event) -> $event



#### 2.3. 修饰符

* stop
* prevent
* .enter
* .once
* .native



### 三. 条件判断

#### 3.1. v-if/v-else-if/v-else



#### 3.2. 登录小案例



#### 3.3. v-show

* v-show和v-if区别



### 四. 循环遍历

#### 4.1. 遍历数组



#### 4.2. 遍历对象

* value
* value, key
* value, key, index

#### 4.3. 数组哪些方法是响应式的



#### 4.4. 作业完成



### 五. 书籍案例



### 六. v-model的使用

#### 6.1. v-model的基本使用

* v-model => v-bind:value v-on:input

#### 6.2. v-model和radio/checkbox/select



#### 6.3. 修饰符

* lazy
* number
* trim



### 七. 组件化开发

#### 7.1. 认识组件化

#### 7.2. 组件的基本使用

#### 7.3. 全局组件和局部组件

#### 7.4. 父组件和子组件

#### 7.5. 注册的语法糖

#### 7.6. 模板的分类写法

* script
* template

#### 7.7. 数据的存放

* 子组件不能直接访问父组件
* 子组件中有自己的data, 而且必须是一个函数.
* 为什么必须是一个函数.

#### 7.8. 父子组件的通信

* 父传子: props
* 子传父: $emit

#### 7.9. 项目

* npm install
* npm run serve



### 一. 组件化开发

#### 1.1. 父子组件的访问

* children/refs
* parent/root



#### 1.2. slot的使用

* 基本使用
* 具名插槽
* 编译的作用域
* 作用域插槽



### 二. 前端模块化

#### 2.1. 为什么要使用模块化

* 简单写js代码带来的问题
* 闭包引起代码不可复用.
* 自己实现了简单的模块化
* AMD/CMD/CommonJS

#### 2.2. ES6中模块化的使用

* export
* import



### 三. webpack

#### 3.1. 什么是webpack

* webpack和gulp对比
* webpack依赖环境
* 安装webpack



#### 3.2. webpack的起步

* webpack命令
* webpack配置: webpack.config.js/package.json(scripts)



#### 3.3. webpack的loader

* css-loader/style-loader
* less-loader/less
* url-loader/file-loader
* babel-loader



#### 3.4. webpack中配置Vue

* vue-loader



#### 3.5. webpack的plugin



#### 3.6. 搭建本地服务器

* webpack-dev-server



#### 3.7. 配置文件的分离





### 四. Vue CLI

#### 4.1. 什么是CLI

* 脚手架是什么东西.
* CLI依赖webpack,node,npm
* 安装CLI3 -> 拉去CLI2模块



#### 4.2. CLI2初始化项目的过程



#### 4.3. CLI2生产的目录结构的解析





export(导出)/import(导入)



.vue



dist -> distribution(发布)



>webpack ./src/main.js ./dist/bundle.js



开发时依赖

运行时依赖一. Vue CLI

#### 1.1. runtime-compiler和runtime-only的区别

* ESLint到底是什么?


* template -> ast -> render -> vdom -> 真实DOM
* render: (h) => h, -> createElement



#### 1.2. Vue CLI3

* 如何通过CLI3创建项目
* CLI3的目录结构
* 配置文件: 1.Vue UI 2.隐藏的配置文件 3.自定义vue.config.js



### 二. Vue-Router

#### 2.1. 什么是前端路由

* 后端渲染\后端路由
* 前后端分离
* SPA\前端路由

#### 2.2. 路由的基本配置

* 安装vue-router
* Vue.use -> 创建VueRouter对象 -> 挂在到Vue实例上
* 配置映射关系: 1.创建组件 2.配置映射关系 3.使用router-link/router-view

#### 2.3. 细节处理

* 默认路由: redirect
* mode: history
* router-link -> tag/replace/active-class

#### 2.4. 动态路由

* /user/:id
* this.$route.params.id



#### 2.5. 参数的传递

* params
* query -> URL
* URL: 
  * 协议://主机:端口/路径?查询
  * scheme://host:port/path?query#fragment

#### 2.6. 路由嵌套

* children: []



#### 2.7. 导航守卫

* 全局导航守卫
* 路由独享守卫
* 组件类守卫



#### 2.8. Keep-alive



#### 2.9. TabBar的封装过程



C:\Users\Administrator\AppData\Roaming



vue init webpack project

runtime+compiler和runtime-only





template -> ast -> render -> virtual dom -> 真实DOM



vue2.5.21 -> vue2.x -> flow-type(facebook)



Vue3.x -> TypeScript(micro(微小)soft(软件)) 



future: 将来/未来

fut: 特性



rc -> run command



vcs -> version control system(版本控制git/svn)



什么是前端渲染, 什么是后端渲染?

什么是前后端分离?

什么是前端路由, 什么是后端路由?



href -> hyper reference



### 一. Vue CLI

#### 1.1. runtime-compiler和runtime-only的区别

* ESLint到底是什么?


* template -> ast -> render -> vdom -> 真实DOM
* render: (h) => h, -> createElement



#### 1.2. Vue CLI3

* 如何通过CLI3创建项目
* CLI3的目录结构
* 配置文件: 1.Vue UI 2.隐藏的配置文件 3.自定义vue.config.js



### 二. Vue-Router

#### 2.1. 什么是前端路由

* 后端渲染\后端路由
* 前后端分离
* SPA\前端路由

#### 2.2. 路由的基本配置

* 安装vue-router
* Vue.use -> 创建VueRouter对象 -> 挂在到Vue实例上
* 配置映射关系: 1.创建组件 2.配置映射关系 3.使用router-link/router-view

#### 2.3. 细节处理

* 默认路由: redirect
* mode: history
* router-link -> tag/replace/active-class

#### 2.4. 动态路由

* /user/:id
* this.$route.params.id



#### 2.5. 参数的传递

* params
* query -> URL
* URL: 
  * 协议://主机:端口/路径?查询
  * scheme://host:port/path?query#fragment

#### 2.6. 路由嵌套

* children: []



#### 2.7. 导航守卫

* 全局导航守卫
* 路由独享守卫
* 组件类守卫



#### 2.8. Keep-alive



#### 2.9. TabBar的封装过程



C:\Users\Administrator\AppData\Roaming



vue init webpack project

runtime+compiler和runtime-only





template -> ast -> render -> virtual dom -> 真实DOM



vue2.5.21 -> vue2.x -> flow-type(facebook)



Vue3.x -> TypeScript(micro(微小)soft(软件)) 



future: 将来/未来

fut: 特性



rc -> run command



vcs -> version control system(版本控制git/svn)



什么是前端渲染, 什么是后端渲染?

什么是前后端分离?

什么是前端路由, 什么是后端路由?



href -> hyper reference



### 一. Promise

#### 1.1. Promise的基本使用

* 如何将异步操作放入到promise中
* (resolve, reject) => then/catch



#### 1.2. Promise的链式调用



#### 1.3. Promise的all方法





### 二. Vuex

#### 2.1. 什么是状态管理



#### 2.2. Vuex的基本使用

* state -> 直接修改state(错误)
* mutations -> devtools



#### 2.3. 核心概念

* state -> 单一状态树
* getters -> 
* mutations -> 
* actions -> 异步操作(Promise)
* modules



#### 2.4. 目录组织方式





### 三. 网络请求封装

#### 3.1. 网络请求方式的选择



#### 3.2. axios的基本使用



#### 3.3. axios的相关配置



#### 3.4. axios的创建实例



#### 3.5. axios的封装



#### 3.6. axios的拦截器





### 四. 项目开发

#### 4.1. 划分目录结构



#### 4.2. 引用了两个css文件



#### 4.3. vue.config.js和.editorconfig



#### 4.4. 项目的模块划分: tabbar -> 路由映射关系



#### 4.5. 首页开发

* navbar 的封装
* 网络数据的请求
* 轮播图
* 推荐信息



```
git remote add origin https://github.com/coderwhy/testmall.git
git push -u origin master
```















sync -> 同步

async -> 异步



aysnc operation: 操作



xcode/iphonex/xml

token -> 



linus -> linux/git



# 项目一些思路

### 一. 项目基本设置

#### 1.1. 目录结构

- network
- components -> common/content
- pages -> 路由分层
- common 
- assets
- router
- store



#### 1.2. 设置CSS初始化和全局样式

- initialize.css
- base.css



#### 1.3. tabbar的封装

- 封装HYTabbar
- 封装HYTabbarItem
- 响应点击切换的设计
- 封装完成后，使用时对HYTabbar重新包装



#### 1.4. axios的封装

- 创建axios实例
- 拦截响应，返回.data数据
- 根据传入的options发送请求，并且调用对应resolve和reject



### 二. 首先开发

#### 2.1. navbar的封装和使用

- 封装navbar包含三个插槽：left、center、right
- 设置navbar相关的样式
- 使用navbar实现首页的导航栏



#### 2.2. 请求首页数据

- 封装请求首页更多数据
- 将banner数据放在banners变量中
- 将recommend数据放在recommends变量中



#### 2.3. 根据Swiper封装HomeSwiper

- 使用Swiper和SwiperItem
- 传入banners进行展示



#### 2.4. 封装FeatureView

- 传入recommends数据，进行展示



#### 2.5. 封装RecommendView

- 展示一张图片即可



#### 2.6. 封装tabControl

- 基本结构的封装
- 监听点击



#### 2.7. 请求和保存商品数据

- 定义goodsList变量，用于存储请求到的商品数据
- 根据type和page请求商品数据
- 将商品数据保存起来



#### 2.8. 封装GoodsList和GoodsListItem

- 展示商品列表，封装GoodsList
- 列表中每一个商品，封装GoodsListItem
- 注意CSS属性的设置即可



#### 2.9. 滚动的封装Scroll

- 学习BetterScroll的使用
- 安装better-scroll
- 封装一个独立的组件，用于作为滚动组件：Scroll
- 组件内代码的封装：
  - 1.创建BetterScroll对象，并且传入DOM和选项（probeType、click、pullUpLoad）
  - 2.监听scroll事件，该事件会返回一个position
  - 3.监听pullingUp事件，监听到该事件进行上拉加载更多
  - 4.封装刷新的方法：this.scroll.refresh()
  - 5.封装滚动的方法：this.scroll.scrollTo(x, y, time)
  - 6.封装完成刷新的方法：this.scroll.finishedPullUp



#### 2.10. 上拉加载更多

- 通过Scroll监听上拉加载更多。
- 在Home中加载更多的数据。
- 请求数据完成后，调动finishedPullUp



#### 2.11. 返回顶部

- 封装BackTop组件
- 定义一个常量，用于决定在什么数值下显示BackTop组件
- 监听滚动，决定BackTop的显示和隐藏
- 监听BackTop的点击，点击时，调用scrollTo返回顶部



#### 2.12. tabControl的停留

- 重新添加一个tabControl组件（需要设置定位，否则会被盖住）
- 在updated钩子中获取tabControl的offsetTop
- 判断是否滚动超过了offsetTop来决定是否显示新添加的tabControl

### 一. FeatureView

* 独立组件封装FeatureView
  * div>a>img	



### 二. TabControl

* 独立组件的封装
  * props -> titles
  * div>根据titles v-for遍历 div -> span{{title}}
  * css相关
  * 选中哪一个tab, 哪一个tab的文字颜色变色, 下面border-bottom
    * currentIndex



### 三. 首页商品数据的请求

#### 3.1. 设计数据结构, 用于保存数据

goods: {

pop: page/list

new: page/list

sell: page/list

}



#### 3.2. 发送数据请求

* 在home.js中封装getHomeGoods(type, page)
* 在Home.vue中, 又在methods中getHomeGoods(type)
* 调用getHomeGoods('pop')/getHomeGoods('new')/getHomeGoods('sell')
  * page: 动态的获取对应的page
* 获取到数据: res
  * this.goods[type].list.push(...res.data.list)
  * this.goods[type].page += 1

goods: {

pop: page1:/list[30]

new: page1/list[30]

sell: page1/list[30]

}

### 四. 对商品数据进行展示

#### 4.1. 封装GoodsList.vue组件

* props: goods -> list[30]
* v-for goods -> GoodsListItem[30]
* GoodListItem(组件) -> GoodsItem(数据)



#### 4.2. 封装GoodsListItem.vue组件

* props: goodsItem 
* goodsItem 取出数据, 并且使用正确的div/span/img基本标签进行展示



### 五. 对滚动进行重构: Better-Scroll

#### 5.1. 在index.html中使用Better-Scroll

* const bscroll = new BScroll(el, {   })
* 注意: wrapper -> content -> 很多内容
* 1.监听滚动
  * probeType: 0/1/2(手指滚动)/3(只要是滚动)
  * bscroll .on('scroll', (position) => {})
* 2.上拉加载
  * pullUpLoad: true
  * bscroll .on('pullingUp', () => {})
* 3.click: false
  * button可以监听点击
  * div不可以

#### 5.2. 在Vue项目中使用Better-Scroll

* 在Profile.vue中简单的演示
* 对Better-Scroll进行封装: Scroll.vue
* Home.vue和Scroll.vue之间进行通信
  * Home.vue将probeType设置为3
  * Scroll.vue需要通过$emit, 实时将事件发送到Home.vue

### 六. 回到顶部BackTop

#### 6.1. 对BackTop.vue组件的封装



#### 6.2. 如何监听组件的点击

* 直接监听back-top的点击, 但是可以直接监听?
  * 不可以, 必须添加修饰.native
* 回到顶部
  * scroll对象, scroll.scrollTo(x, y, time)
  * this.$refs.scroll.scrollTo(0, 0, 500)



#### 6.3. BackTop组件的显示和隐藏 

* isShowBackTop: false
* 监听滚动, 拿到滚动的位置:
  * -position.y > 1000  -> isShowBackTop: true
  * isShowBackTop = -position.y > 1000





### 七. 解决首页中可滚动区域的问题

* Better-Scroll在决定有多少区域可以滚动时, 是根据scrollerHeight属性决定
  * scrollerHeight属性是根据放Better-Scroll的content中的子组件的高度
  * 但是我们的首页中, 刚开始在计算scrollerHeight属性时, 是没有将图片计算在内的
  * 所以, 计算出来的告诉是错误的(1300+)
  * 后来图片加载进来之后有了新的高度, 但是scrollerHeight属性并没有进行更新.
  * 所以滚动出现了问题
* 如何解决这个问题了?
  * 监听每一张图片是否加载完成, 只要有一张图片加载完成了, 执行一次refresh()
  * 如何监听图片加载完成了?
    * 原生的js监听图片: img.onload = function() {}
    * Vue中监听: @load='方法'
  * 调用scroll的refresh()
* 如何将GoodsListItem.vue中的事件传入到Home.vue中
  * 因为涉及到非父子组件的通信, 所以这里我们选择了**事件总线**
    * bus ->总线
    * Vue.prototype.$bus = new Vue()
    * this.bus.emit('事件名称', 参数)
    * this.bus.on('事件名称', 回调函数(参数))


* 问题一: refresh找不到的问题
  * 第一: 在Scroll.vue中, 调用this.scroll的方法之前, 判断this.scroll对象是否有值
  * 第二: 在mounted生命周期函数中使用 this.$refs.scroll而不是created中
* 问题二: 对于refresh非常频繁的问题, 进行防抖操作
  * 防抖debounce/节流throttle(课下研究一下)
  * 防抖函数起作用的过程:
    * 如果我们直接执行refresh, 那么refresh函数会被执行30次.
    * 可以将refresh函数传入到debounce函数中, 生成一个新的函数.
    * 之后在调用非常频繁的时候, 就使用新生成的函数.
    * 而新生成的函数, 并不会非常频繁的调用, 如果下一次执行来的非常快, 那么会将上一次取消掉

```js
      debounce(func, delay) {
        let timer = null
        return function (...args) {
          if (timer) clearTimeout(timer)
          timer = setTimeout(() => {
            func.apply(this, args)
          }, delay)
        }
      },
```



### 八. 上拉加载更多的功能

y  ifu

### 九. tabControl的吸顶效果

#### 9.1. 获取到tabControl的offsetTop

* 必须知道滚动到多少时, 开始有吸顶效果, 这个时候就需要获取tabControl的offsetTop
* 但是, 如果直接在mounted中获取tabControl的offsetTop, 那么值是不正确.
* 如何获取正确的值了?
  * 监听HomeSwiper中img的加载完成.
  * 加载完成后, 发出事件, 在Home.vue中, 获取正确的值.
  * 补充:
    * 为了不让HomeSwiper多次发出事件,
    * 可以使用isLoad的变量进行状态的记录.
  * 注意: 这里不进行多次调用和debounce的区别

#### 9.2. 监听滚动, 动态的改变tabControl的样式

* 问题:动态的改变tabControl的样式时, 会出现两个问题:
  * 问题一: 下面的商品内容, 会突然上移
  * 问题二: tabControl虽然设置了fixed, 但是也随着Better-Scroll一起滚出去了.
* 其他方案来解决停留问题.
  * 在最上面, 多复制了一份PlaceHolderTabControl组件对象, 利用它来实现停留效果.
  * 当用户滚动到一定位置时, PlaceHolderTabControl显示出来.
  * 当用户滚动没有达到一定位置时, PlaceHolderTabControl隐藏起来.



### 十. 让Home保持原来的状态

#### 10.1. 让Home不要随意销毁掉

* keep-alive

#### 10.2. 让Home中的内容保持原来的位置

* 离开时, 保存一个位置信息saveY.
* 进来时, 将位置设置为原来保存的位置saveY信息即可.
  * 注意: 最好回来时, 进行一次refresh()











非父子组件通信:

https://www.jb51.net/article/132371.htm







