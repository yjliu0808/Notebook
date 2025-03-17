笔记来源：《2019年最全最新Vue、Vuejs教程，从⼊⻔到精通》课程介绍

1、邂逅vue
2、vue基础语法
3、组件化开发
4、vue CLI详情
5、vue-router
6、vuex详情
7、网络封装
8、项目实战
9、项目部署
10、vuejs原理

### 一、认识vue

官方地址：https://cn.vuejs.org/

- Vue.js 是一个**渐进式**的 JavaScript 框架，主要用于构建用户界面。渐进式意味着您可以根据项目的需求逐步采用 Vue 的功能。与其他框架（如 Angular）不同，Vue 的设计初衷是尽量避免开发人员必须一次性学习和掌握大量复杂的工具和概念。开发者可以先将 Vue 用作一个简单的视图层库，然后逐步使用其生态系统中的其他工具（如 Vue Router、Vuex 等），来构建完整的前端应用
- vuejs**Vue.js** 和 **Vue** 实际上是指同一个东西，**Vue** 通常是 Vue.js 的简称。
  **Vue.js**：全称是 **Vue JavaScript**，是指 Vue 这个前端框架的完整名称。Vue.js 是一个用于构建用户界面的 JavaScript 框架。**Vue**：Vue.js 的简写，开发者习惯性称呼其为 Vue。
  无论是使用 **Vue.js** 还是 **Vue**，它们都指的是同一个前端框架，没有实际上的区别。通常在口头或书面交流中，大家更倾向于使用 **Vue** 这个简短的名称，因为它更便捷。而 **Vue.js** 是在介绍或正式场合中使用的完整名称。

■Vue (读音 /vju:/,类似于 view)，不要读错。
Vue是一个渐进式的框架，什么是渐进式的呢 ?
 渐进式意味着你可以将Vue作为你应用的一部分嵌入其中，带来更丰富的交互体验。
 或者如果你希望将更多的业务逻辑使用Vue实现，那么Vue的核心库以及其生态系统
 比如Core+Vue-router+Vuex，也可以满足你各种各样的需求。
Vue有很多特点和Web开发中常见的高级功能
解耦视图和数据
可复用的组件
前端路由技术
状态管理
虚拟DOM

#### Demo1-初体检vue

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <div id ="app">
        <h1>{{message}}</h1>
        <h1>{{name}}</h1>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const name = new Vue(
            {
             el:'#app',//用于要挂载管理的元素
             data:{//定义数据
                message:'你好，初体检vue!',
                name:"姓名:Athena!"
             }   
            }
        )
    </script>
</body>
</html>
```

#### Demo2-列表数据

```
 <!DOCTYPE html>
 <html lang="en">
 <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
 </head>
 <body>
    <div id = "app">
        <ul>
            <li v-for = "item in movies">{{item}}</li>
        </ul>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
        const app = new Vue(
            {
                el:'#app',
                data:{
                    message:'列表展示以下数据：',
                    movies:['志愿军','流浪地球','因果报应','王牌对王牌','流水迢迢']
                }
            }
        )
    </script>
 </body>
 </html>
```

#### Demo4-计数器

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <div id = "app">
        <h1>
          当前计数：{{counter}}  
        </h1>
        <!-- <button v-on:click=counter++>+</button>
        <button v-on:click="counter--">-</button> -->
        <button v-on:click="add">+</button>
        <button v-on:click="sub">-</button>
       
    </div>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
        const app = new Vue({
            el:'#app',
            data:{
                counter:0
            },
            methods:{
                add:function(){
                    console.log("增1")
                    this.counter++
                },
                sub:function(){
                    console.log("减1")
                this.counter--
                }
            
            }
        })
    </script>
  
</body>
</html>
```

代码规范：
缩进一般2个空格

### 错误记录

1、methods 方法名称写错误了
