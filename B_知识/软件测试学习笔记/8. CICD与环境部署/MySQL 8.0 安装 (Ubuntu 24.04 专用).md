## 🧩 一、卸载旧残留（如之前尝试安装过）

```
sudo apt remove --purge mysql-server mysql-client mysql-common -y
sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql /var/log/mysql.*
sudo apt autoremove -y
sudo apt autoclean
```

------

## 🚀 二、安装 MySQL 官方仓库并安装 8.0 版本

### 1️⃣ 添加 MySQL APT 仓库

```
wget https://dev.mysql.com/get/mysql-apt-config_0.8.32-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.32-1_all.deb
```

安装过程中会弹出菜单，让你选择版本：

- 选中 **MySQL 8.0**
- 其他默认即可（用方向键选择，按 Enter 确认）

更新仓库：

```
sudo apt update
```

------

### 2️⃣ 安装 MySQL 服务器

```
sudo apt install mysql-server -y
```

------

## 🔧 三、启动与状态检查

```
sudo systemctl enable mysql
sudo systemctl start mysql
sudo systemctl status mysql
```

出现 `active (running)` 即表示成功。

------

## 🧰 四、初次登录与安全配置

### 1️⃣ 登录 MySQL

MySQL 8.0 安装后 root 默认用 **auth_socket** 认证，不能直接用密码登录。
 先进入系统后切换：

```
sudo mysql
```

### 2️⃣ 修改 root 登录方式与密码

进入 mysql 控制台后执行：

```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'gP%?qfZS>3/W';
FLUSH PRIVILEGES;
EXIT;
```

现在可以用密码登录：

```
mysql -uroot -p
```

------

## 🔐 五、设置远程访问权限（root允许外部连接）

登录 MySQL 后执行：

```
USE mysql;
UPDATE user SET host='%' WHERE user='root';
FLUSH PRIVILEGES;
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'gP%?qfZS>3/W';
```

------

## 🔥 六、修改防火墙与配置文件（允许外部连接）

### 1️⃣ 打开防火墙 3306 端口

```
sudo ufw allow 3306
sudo ufw reload
```

### 2️⃣ 修改配置文件

```
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf

```

找到：

```
bind-address = 127.0.0.1
```

改为：

```
bind-address = 0.0.0.0
```

保存后重启：

```
sudo systemctl restart mysql
```

------

## 🧪 七、验证连接

本地：

```
mysql -uroot -p
```

远程（例如用 Navicat / DBeaver）：

云服务器开通端口3306

```
Host: 115.159.42.77
Port: 3306
User: root
Password: gP%?qfZS>3/W
```

------

## ✅ 八、常见维护命令

```
sudo systemctl status mysql     # 查看状态
sudo systemctl restart mysql    # 重启
sudo systemctl stop mysql       # 停止
sudo mysql_secure_installation  # 一键安全加固（推荐执行）
```

------

