## tencent服务器部署步骤

所有的均安装到athena 文件夹

```
mkdir /athena 
cd /athena
mkdir mysql
mkdir jdk
mkdir redis
mkdir nginx
ls
```

重新安装系统后基本环境安装：

```
yum -y install wget
yum install gcc-c++ make -y
```

### 安装mysql8操作步骤

```
cd mysql
sudo rpm -Uvh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo yum install mysql-server --nogpgcheck
sudo systemctl start mysqld
sudo systemctl status mysqld
sudo systemctl enable mysqld
systemctl restart mysqld

mysql -uroot -p  
密码默认是空，直接回车
ALTER USER 'root'@'localhost' IDENTIFIED BY 'gP%?qfZS>3/W';
use mysql;  
SHOW VARIABLES LIKE 'validate_password%';
install plugin validate_password soname 'validate_password.so';
SHOW VARIABLES LIKE 'validate_password%';
set global  validate_password_length=6;
set global validate_password_policy=LOW;
update user set host='%' where user='root';
flush privileges;
ALTER USER 'root'@'%' IDENTIFIED BY '123456';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
```

### 安装JDK1.8操作步骤

[JDK1.8下载](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)

```
vim /etc/profile

export JAVA_HOME=/athena/jdk/jdk1.8.0_371
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin

source /etc/profile
java -version
```

### 安装redis操作步骤

```
cd redis
yum install gcc-c++ make -y
gcc -v
wget http://download.redis.io/releases/redis-6.0.8.tar.gz
ls
tar -zxvf redis-6.0.8.tar.gz
ls
cd redis-6.0.8
make PREFIX=/athena/redis/redisMake install
cd /athena/redis/redis-6.0.8/src
ls
./redis-server
./redis-cli shutdown
vim /etc/systemd/system/redis.service
```

```
[Unit]
Description=redis-server
After=network.target
[Service]
Type=forking
# 这行配置内容要根据redis的安装目录自定义路径
ExecStart=/athena/redis/redisMake/bin/redis-server /athena/redis/redis-6.0.8/redis.conf
PrivateTmp=true
[Install]
WantedBy=multi-user.target
```

```
systemctl daemon-reload
systemctl enable redis
reboot
systemctl status redis
```

```
vim /athena/redis/redis-6.0.8/redis.conf

bind		    绑定的主机地址,如果需要设置远程访问则直接将这个属性#注释
protected-mode	如需外网连接rendis服务则需要将此属性改为no。
requirepass 123456
服务器开放6379端口后外网验证
telnet 101.35.51.221 6379 

netstat -ntulp
./redis-server --protected-mode no &
```

### 安装nginx操作步骤

```
sudo dnf install -y epel-release
sudo dnf install -y nginx
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx
reboot
sudo systemctl restart nginx
cd /usr/share/nginx/html
vim /etc/nginx/nginx.conf
```



安装redis操作步骤

```
sudo dnf install -y epel-release
sudo dnf install -y redis

sudo systemctl start redis

sudo systemctl status redis
sudo systemctl enable redis
sudo systemctl restart redis
vim /etc/redis.conf
```

后台启动jar包服务

```
nohup java -jar mall.jar > mall.log 2>&1 &
```

