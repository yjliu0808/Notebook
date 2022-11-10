+ 安装redis

```
# 安装gcc
yum install gcc-c++ make -y
# gcc -v 看到gcc的版本
#下载安装包
wget http://download.redis.io/releases/redis-6.0.8.tar.gz
$ tar xzf redis-6.0.8.tar.gz
$ cd redis-6.0.8
$ make
# 如果想安装到指定路径： make PREFIX=/usr/local/redis install   指定安装到/usr/local/redis路径
# 启动
$ src/redis-server
ls
/opt/athena/redis/redis-6.0.8/src
[root@10-13-4-67 src]# ./redis-server
 ps aux | grep redis-server

```



/opt/athena/mysql/mysql/bi

```
./mysqld --defaults-file=/etc/my.cnf --basedir=/opt/athena/mysql/mysql/ --datadir=/data/mysql/ --user=mysql --initialize
```



```
[mysqld]
bind-address=0.0.0.0
port=3306
user=mysql
basedir=/usr/local/soft/mysql  # mysql安装目录
datadir=/data/mysql  # 数据存放目录
socket=/tmp/mysql.sock
log-error=/data/mysql/mysql.err
pid-file=/data/mysql/mysql.pid
#character config
character_set_server=utf8mb4
symbolic-links=0
explicit_defaults_for_timestamp=true
```





```
[mysqld]
bind-address=0.0.0.0
port=3306
user=mysql
basedir=/opt/athena/mysql/mysql # mysql安装目录
datadir=/data/mysql  # 数据存放目录
socket=/tmp/mysql.sock
log-error=/data/mysql/mysql.err
pid-file=/data/mysql/mysql.pid
#character config
character_set_server=utf8mb4
symbolic-links=0
explicit_defaults_for_timestamp=true
```

```
./mysql -uroot -pH*kea1#k_>xa
```



```
./mysqld --defaults-file=/etc/my.cnf --basedir=/opt/athena/mysql/mysql --datadir=/data/mysql/ --user=root --initialize
```



```
yum install gcc-c++ make -y

# 升级gcc
$ yum -y install centos-release-scl
$ yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
$ scl enable devtoolset-9 bash
$ echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile
# 此时，通过gcc -v 看到gcc的版本应该是在9以上

```

```
$ wget http://download.redis.io/releases/redis-6.0.8.tar.gz
$ tar xzf redis-6.0.8.tar.gz
$ cd redis-6.0.8
$ make

# 如果想安装到指定路径： make PREFIX=/usr/local/redis install   指定安装到/usr/local/redis路径

# 启动
$ src/redis-server
[root@10-13-4-67 src]# ./redis-server 

```

二、找到redis的配置文件 redis.conf

vim redis.conf

修改 protected-mode yes 改为：protected-mode no





```
ls -l /proc/28397/cwd
```



```
cp /opt/athena/mysql/mysql/support-files/mysql.server /etc/init.d/mysql

```

ln -s libncurses.so.6 libncurses.so.5

```
cp /usr/local/soft/mysql/support-files/mysql.server /etc/init.d/mysql
```





https://cloud.tencent.com/developer/article/1646056

ln -s /opt/athena/mysql/mysql/bin/mysql    /usr/bin









```
url: jdbc:mysql://106.75.169.238:3306/mall_tiny?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai
```