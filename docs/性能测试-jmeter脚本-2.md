### 待定

#### 1.websocket

##### 1.什么是websocket协议?

##### jmeter如何来测试websocket协议？

+ jmeter中要引入插件， jmeter本身的取样器中，不支持websocket协议
+ 插件管理.jar   jmeter-plugins-manager-1.6.jar
  + jar包 jmeter的lib\ext文件夹中， 这个文件夹下放第三方开发的jar
  + 再启动jmeter
  + jmeter的菜单  > 选项   > plugin manager的入口(没有放plugin的jar包时，没有这个入口)
  + 点击入口，出现插件管理弹窗
    + Installed plugins   已安装
    + Available plugins   可用的，但是需要你手动去安装
      + 搜索： websocket 
      + 勾选        WebSocket Samplers by Peter Doornbosch    
      + 点击  右下角  apply changes and restart jmeter
    + upgrades  可以升级

写脚本

+ 取样器
  + websocket close   关闭websocket
  + websocket open connection  建立一个websocket
  + websocket ping/pong  测试websocket协议
  + websocket single read sampler   客户端从服务器端口获取
  + websocket single write sampler   客户端向服务端发请求(不会获取响应)
  + websocket request-response sampler   同时具备向服务端发请求 和 获取响应功能

WebSocket Single Write Sampler

+ connect：
  + user exist connection  使用已经建立连接
  + setup new connection   新建一个连接
+ Data:
  + 数据： text 文本    binary 二进制
  + request data

监听：

+ 绿色，只是代表网络成功， response code 并不一定等于200
  + 它的响应码： 1xx、2xx、3xx
+ 红色，失败，

websocket项目

+ python3编写
+ 服务： websocketd













#### 2.MQ: 消息队列的总称

+ kfaka
+ rabaitmq
+ MQTT
+ 队列： FIFO   fist in fist out    顺序队列，循环队列
  + 发布与订阅

```
1、sudo yum install -y yum-utils device-mapper-persistent-data lvm2
2、sudo yum-config-manager --add-repo https://repos.emqx.io/emqx-ce/redhat/centos/7/emqx-ce.repo
3、curl https://repos.emqx.io/install_emqx.sh | bash
 systemctl start emqx

```

+ MQTT : 
  + 支持 http协议
  + 支持websocket协议
  + 支持mq协议

##### jmeter下载mqtt的协议插件

+ MQTT Protocol Support   如果下载失败，左边有红色， 再次点击  apply changes  and restat jmeter



dubbo： 微信服务器框架协议， 不对外暴露接口

远程rpc服务调用， server服务 + 注册中心+ 消费者

把server部署到 3台机器  ====3server （10个方法[adduser]） ------注册到注册中心 zookeeper（3台机器ip/port，10个方法地址）

管理者 monitor

消费者（可以是的代码，一般情况下是开发人员写的代码）

+ 接口  vs  方法： 
  + 根据不同的协议，向外暴露，供外部调用
  + 方法，不需要特定协议，一般不对外暴露，  代码之间的 方法直接调用

+ 我们这个项目的zookeeper的端口： 20181
  + zookeeper的默认端口： 2181

+ jmeter测试dubbo
  + jmeter-plugins-dubbo-2.7.3-jar-with-dependencies.jar 丢到jmeter的lib\ext
  + dubbo取样器中，register seting
    + 选择zookeeper
    + 机器ip:20181
    + Interface setting   点击  get provider list







