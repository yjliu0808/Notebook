### 持续集成工具Jenkins

1. 基于Java开发的持续集成工具
2. 可用于监控持续重复的工作
3. 软件版本发布/**项目测试**
4. 功能测试： 用它来打包，部署环境
5. 自动化测试： 打包代码，运行代码，进行自动化测试
6. 性能测试： 打包性能脚本，进行性能测试，获得性能报告

#### 1.下载/安装Jenkins

- 官网下载：https://jenkins.io/download/

<div align="left"> <img src="pics/jenkins1.png" /> </div><br>

#### 2.环境搭建

- 下载war包：jenkins.war
- 下载tommcat包,[部署tomcat环境](https://github.com/yjliu0808/Notebook/blob/master/docs/Linux%E7%B3%BB%E7%BB%9F%E4%B8%AD%E9%85%8D%E7%BD%AETomcat.md)
- 部署到tomcat（将war包放置到tomcat目录下的webapps文件夹下）
  启动Tomcat（在tomcat的bin目录中找到startup.bat执行启动）
  验证：
  http://localhost:8080验证Tomcat
  http://localhost:8080/jenkins验证Jenkins

#### 3.重新安装jenkins

- 若需要删此文件重新部署才生效

<div align="left"> <img src="pics/jenkins2.png" /> </div><br>

#### 4.jenkins密码设置

- 在第一次使用jenkins的时候默认会生成一个密码文件
- 打开文件，复制其中的初始登录的密码，粘贴然后登录

<div align="left"> <img src="pics/jenkins3.png" /> </div><br>

<div align="left"> <img src="pics/jenkins4.png" /> </div><br>

5.安装插件

<div align="left"> <img src="pics/jenkins5.png" /> </div><br>

<div align="left"> <img src="pics/jenkins6.png" /> </div><br>

#### 6.使用Jenkins

<div align="left"> <img src="pics/jenkins7.png" /> </div><br>

<div align="left"> <img src="pics/jenkins8.png" /> </div><br>

#### 7.Jenkins + jmeter + ant 集成

##### 1.安装ant插件

- 确保 ant插件已经安装

- [Ant下载](https://ant.apache.org/bindownload.cgi)

- 配置ant本地路径

  <div align="left"> <img src="pics/jenkins10.png" /> </div><br>

  <div align="left"> <img src="pics/jenkins11.png" /> </div><br>

  <div align="left"> <img src="pics/jenkins9.png" /> </div><br>

##### 2.配置ant

<div align="left"> <img src="pics/jenkins12.png" /> </div><br>

<div align="left"> <img src="pics/jenkins13.png" /> </div><br>

##### 3.新建item

+ 构建： invoke ant

+ 高级配置： 一定要选择你的jmeter的extas文件夹中的build.xml

  <div align="left"> <img src="pics/jenkins14.png" /> </div><br>

  <div align="left"> <img src="pics/jenkins15.png" /> </div><br>

  <div align="left"> <img src="pics/jenkins16.png" /> </div><br>

  <div align="left"> <img src="pics/jenkins18.png" /> </div><br>

  <div align="left"> <img src="pics/jenkins17.png" /> </div><br>

  









# 





+ 配置本地ant
  + 配置ANT_HOME 环境变量
  + 修改jmeter的jmeter.properties 中，有个output_format
    + jmeter.save.saveservice.output_format=xml
  + jmeter的extras文件夹中 ant-jmeter-1.1.1.jar  拷贝到ant的lib文件  ----发邮件
+ build.xml
  + project:  有且仅有一个
    + default=all   默认情况下，会执行任务名称为all的任务，all的任务，它包含了test、report、mail  也就是说，默认情况下，会执行测试入围、生成报告任务、发送邮件任务。
    + 在jenkins的item中配置  构建 invoke ant中 也有targets， 如果这个targets没有填，那么就根据build.xml文件中default值来执行，如果有填，就执行你填写的任务。如果targets 如果想要填多个，点击右侧 下三角图标，然后 回车换行的方式填写多个。
+ jenkins构建
  + 开始构建之前： 
    + 先启动项目
    + 检查jmx中的启用的线程组场景设计的

