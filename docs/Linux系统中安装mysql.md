### Linux安装mysql数据库

#### 1.上传离线安装包

在/usr/local 下新建 mysql 文件夹，将 mysql 的离线安装包通过 ftp 工具上传到该文件夹下解压文件。

#### 2.开始安装

```sql
rpm -ivh mysql-community-common-8.0.28-1.el7.x86_64.rpm
rpm -ivh mysql-community-libs-8.0.28-1.el7.x86_64.rpm --nodeps --force
rpm -ivh mysql-community-libs-8.0.27-1.el7.x86_64.rpm --nodeps --force
rpm -ivh mysql-community-client-8.0.28-1.el7.x86_64.rpm --nodeps --force
rpm -ivh mysql-community-server-8.0.28-1.el7.x86_64.rpm --nodeps --force
说明:   --force：强制安装  --nodeps：不考虑相依属性的关系
```

安装完成，启动服务： 

```sql
systemctl start mysqld
```

查看mysql服务是否启动：

```sql
netstat -nat | grep 3306
```

#### 3.设置密码

```sql
sudo grep 'temporary password' /var/log/mysqld.log 
```

 得到一个临时密码，登录：mysql -uroot -p，输入上面得到的临时密码，进入mysql以后，将密码强度等级设置为最低。

设置密码

```sql
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
mysql> set global validate_password.policy=0;
Query OK, 0 rows affected (0.00 sec)
mysql> set global validate_password.length=1;
Query OK, 0 rows affected (0.00 sec)
mysql> alter user user() identified by "root";
```

设置可远程登陆

刚开始安装默认帐号不允许从远程登陆，只能在localhost，通过下面命令修改表：

```sql
mysql -u root -prootroot
use mysql;
update user set host = '%' where user = 'root';
flush privileges;
select host, user from user;
```

或者通过下面的方法授权远程登陆：

```sql
grant all privileges on *.* to root@'%' identified by 'rootroot' with grant option;
```



### 