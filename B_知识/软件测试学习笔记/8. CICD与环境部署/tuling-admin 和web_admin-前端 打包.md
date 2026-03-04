# tuling-admin — 用户后台管理模块

> **mall 项目（图灵商城）后台管理服务**
> **运行环境：Java 1.8**

------

## 一、运行环境要求

| 项目         | 要求                                  |
| ------------ | ------------------------------------- |
| **JDK 版本** | **Java 1.8（必须，不能用 11/17/21）** |
| Maven        | 3.6+                                  |
| MySQL        | 5.7 / 8.0                             |
| Redis        | 必须（缓存模块）                      |

------

## 二、快速打包

#### 1. 打包开发环境（DEV）

```
mvn clean package -Pdev -am -DskipTests

```

#### 2. 打包生产环境（PROD）

```
mvn clean package -Pprod -am -DskipTests

```

------

## 三、后台运行命令

#### 1. 切换到 JDK 1.8 环境并运行 JAR 文件

**首先，切换到 JDK 1.8 环境：**

```
"D:\install\Program\java\jdk1.8.0_202\bin\java" -jar D:\install\Program\mall\tuling-admin-dev.jar

```

#### 2、设置开机自启的bat文件

```
@echo off
cd /d "D:\install\Program\mall"
"D:\install\Program\java\jdk1.8.0_202\bin\java" -jar tuling-admin-dev.jar > mall.log 2>&1

```

#### 2. Redis 启动

确保 Redis 已启动并运行，使用默认配置：

```
redis-server
```

设置开机自启的bat文件

```
@echo off
cd /d %~dp0
redis-server.exe redis.conf
pause

```



# tuling_mall_web_admin-前端项目

1、切换到此项目路径下：

```
cd .\tuling_mall_web_admin\

```

2、切换nodejs 版本

```
nvm use 12.22.12
node -v

```

在IDEA命令行中运行命令

```
npm install
npm run dev  //用的prod.env.js 配置文件
npm run build  //用的prod.env.js 配置文件
```

此版本只能打包运行用的prod.env.js 配置文件

[nginx配置参考](https://github.com/yjliu0808/Notebook/blob/main/B_%E7%9F%A5%E8%AF%86/%E8%BD%AF%E4%BB%B6%E6%B5%8B%E8%AF%95%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/8.%20CICD%E4%B8%8E%E7%8E%AF%E5%A2%83%E9%83%A8%E7%BD%B2/Vue%202%20%E9%A1%B9%E7%9B%AE%E5%AE%8C%E6%95%B4%E7%94%9F%E4%BA%A7%E7%8E%AF%E5%A2%83%E6%89%93%E5%8C%85%E4%B8%8E%E9%83%A8%E7%BD%B2%E6%8C%87%E5%8D%97.md)

