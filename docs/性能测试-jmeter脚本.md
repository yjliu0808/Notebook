### 性能测试—jmeter脚本

#### 1.环境及项目部署

- 本地安装VMware虚拟机：[下载地址](https://pan.baidu.com/s/1Nfq1LnkovlEOXeHsXWq99A)

- 下载test项目：[下载地址](https://pan.baidu.com/s/1FxHr_C1pWM1OOknRAV2v9Q)

- VMware中导入test项目(.ova)文件

- 备注：

  1. 首次导入出现报错提示，尝试重试即可

  2. 编辑虚拟机设置：修改内存、处理器、网络配置项（可用NAT模式）

     <div align="left"> <img src="pics/vmware1.png" width="800"/> </div><br>

  3. 登录账密（root/123456）ifconfig查看本机ip：

     <div align="left"> <img src="pics/vmware2.png" width="800"/> </div><br>

     

#### 2.启动tomcat

- 项目基本信息：
  1. tomcat安装路径：   /opt/apache-tomcat-8
  2. jdk版本：1.7  
  3. docker方式安装的mysql，开机自启动mysql

- 启动tomcat

  ```shell
  cd /opt/apache-tomcat-8.5.56/bin
  ./startup.sh  
  ```

#### 3.API文档



#### 4.运行jmeter脚本



