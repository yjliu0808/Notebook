#### 监控平台zabbix  

1. zabbix： 服务器资源监控平台

2. zabbix 应用:

   + grafana(前端展示) + zabbix

   + zabbix本身前端 + 数据库 + 数据收集
   + 不局限于性能测试,可以独立监控硬件资源 + 软件资源
   + 组成有多个:最主要的zabbix-server    zabbix-agent(收集安装被测服务器)

##### 1.zabbix安装

```shell
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm

yum clean all

yum install zabbix-server-mysql zabbix-agent -y

yum install centos-release-scl -y

vim /etc/yum.repos.d/zabbix.repo
[zabbix-frontend]
enable =1


yum install zabbix-web-mysql-scl zabbix-nginx-conf-scl -y 
```



```sh
rpm -Uvh http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm

rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

yum install mysql-community-server -y

systemctl restart mysqld

vim /etc/my.cnf
# 添加validate_password_policy配置 0（LOW），1（MEDIUM），2（STRONG）
validate_password_policy=0
# 关闭密码策略
validate_password = off
# 设置字符集
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_general_ci
init_connect='SET NAMES utf8mb4'

# 再次重启mysqld
systemctl restart mysqld

```

 

改mysql的root密码

```
grep "password" /var/log/mysqld.log

# 复制密码 (1Hatgt*qc1yh)

mysql -uroot -p回车
黏贴上面复制密码  回车

ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';

# 开启远程访问
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit;

systemctl restart mysqld
```



```
# 初始化zabbix的数据库
mysql -uroot -p回车
密码：123456

# 创建数据库
create database zabbix character set utf8 collate utf8_bin;

# 创建zabbix账号并赋予权限
create user zabbix@localhost identified by 'zabbix123';
grant all privileges on zabbix.* to zabbix@localhost;
quit;

# 初始化表结构和数据
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
输入密码： zabbix123
```



修改zabbix_server的配置文件

```
vim /etc/zabbix/zabbix_server.conf
DBPassword=zabbix123
```



修改zabbix前端配置

```
vim /etc/opt/rh/rh-nginx116/nginx/conf.d/zabbix.conf
把第2、3行前面的# 去掉
```

```
vim /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
listen.acl_users = apache,nginx
# 去掉最后一行前面 ;
#把 时区  Asia/Shanghai
```



zabbix：

+ selinux权限 
+ nginx配置：nginx默认端口就是 80
+ centos 7 + zabbix + mysql + nginx
  + zabbix： server、agent

