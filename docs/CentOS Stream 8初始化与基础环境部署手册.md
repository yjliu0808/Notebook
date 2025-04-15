# 🚀CentOS Stream 8 服务器初始化与基础环境部署手册

> 统一目录：所有软件统一安装在 `/athena` 目录下
>

```
mkdir /athena 
cd /athena
mkdir mysql
mkdir jdk
mkdir redis
mkdir nginx
ls
```

> 基础环境初始化
>

```
yum -y install wget
yum install gcc-c++ make -y
```

## 📥安装 MySQL 8.0

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
//修改密码为复杂一点的密码，云服务器防止病毒
ALTER USER 'root'@'%' IDENTIFIED BY '123456';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';


```

## 📥安装 JDK 1.8

[JDK1.8下载](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)

```
vim /etc/profile

export JAVA_HOME=/athena/jdk/jdk1.8.0_371
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin

source /etc/profile
java -version
```

```
export MAVEN_HOME=/athena/maven/apache-maven-3.9.6
export PATH=$PATH:$MAVEN_HOME/bin

```



## 📥安装 Redis

```
sudo dnf install -y epel-release
sudo dnf install -y redis
sudo systemctl start redis
sudo systemctl status redis
sudo systemctl enable redis
sudo systemctl restart redis
vim /etc/redis.conf
bind		    绑定的主机地址,如果需要设置远程访问则直接将这个属性#注释
protected-mode	如需外网连接rendis服务则需要将此属性改为no。
requirepass 123456
sudo systemctl restart redis  重启服务使生效
服务器开放6379端口后外网验证
telnet 101.35.51.221 6379 
```

## 📥安装 Nginx

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

```
/usr/share/nginx/html/dist   将打包好的dist文件上传即可
```



## ▶️启动java服务

1、手动启动：

```
nohup java -jar mall2.jar > mall.log 2>&1 &
```

2、设置开机自启的步骤：

示例，使用`systemd`来管理进程并实现自动重启：

/etc/systemd/system 路径下 创建一个文本文件，例如 `tuling-admin.service`，并使用文本编辑器打开该文件：

```
[Unit]
Description=Tuling Admin Spring Boot Service
After=network.target

[Service]
User=root
WorkingDirectory=/athena/mall
ExecStart=/athena/jdk/jdk1.8.0_371/bin/java -jar /athena/mall/tuling-admin-0.0.1-SNAPSHOT.jar
SuccessExitStatus=143
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=tuling-admin

[Install]
WantedBy=multi-user.target

```

使用以下命令重新加载 `systemd` 配置并启动服务：

```
$ sudo systemctl daemon-reload
$ sudo systemctl start mall
$ sudo systemctl enable mall
```

## 📥安装  Jenkins

🔢1、添加 Jenkins 源仓库

成功从 Jenkins 官方下载了 `jenkins.repo` 文件
并保存到了 `/etc/yum.repos.d/` 目录中（这个目录是系统用来存放所有 YUM 仓库配置的地方）

```
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
```

🔢2、下载最新版 Jenkins `.war`，保存到系统指定路径中。

```
sudo wget -O /usr/share/java/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war
```

或者指定具体 LTS 版本（比如 2.426.3）：

```
sudo wget -O /usr/share/java/jenkins.war https://get.jenkins.io/war-stable/2.426.3/jenkins.war
```

🔢3、Jenkins 安装前 GPG Key 操作顺序（适配 `jenkins.io-2023.key`）

1.  **先下载 Jenkins 官方 GPG key**

   ```
   curl -O https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
   ```

2. 手动导入 GPG key 到系统（rpm 信任 key 环）

   ```
   sudo rpm --import jenkins.io-2023.key
   ```

3.  **编辑 Jenkins 的 YUM 源配置文件**

   ```
   sudo vi /etc/yum.repos.d/jenkins.repo
   ```

   内容如下（关键是要指向你刚才导入的那把 key）：

   ```
   [jenkins]
   name=Jenkins-stable
   baseurl=https://pkg.jenkins.io/redhat-stable
   gpgcheck=1
   gpgkey=https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
   ```

4. 清缓存 & 更新源（防止历史影响）

   ```
   sudo yum clean all
   sudo rm -rf /var/cache/yum
   sudo yum makecache
   ```

5. 安装 Jenkins（会校验 GPG 签名）

   ```
   sudo yum install -y jenkins
   ```

6. 编辑 Jenkins 配置文件

   ```
   sudo vi /etc/sysconfig/jenkins
   ```

   添加以下内容（确保 Java 17 路径正确）：

   ```
   
   JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.6.0.9-0.3.ea.el8.x86_64
   JENKINS_JAVA_CMD="$JAVA_HOME/bin/java"
   JENKINS_JAVA_OPTIONS="-Xms128m -Xmx384m"
   
   ```

7. 编辑 Jenkins 的 systemd 启动文件

   ```
   sudo vi /usr/lib/systemd/system/jenkins.service
   ```

   ```
   🔍 找到这行（大概在文件中间）
   ExecStart=/usr/bin/jenkins
   ```

   把它修改为下面这样（**显式指定 Java 启动 Jenkins**）：

   ```
   ExecStart=/athena/jdk/jdk1.8.0_371/bin/java -Djava.awt.headless=true -jar /usr/share/java/jenkins.war
   
   ```

   ⚠️ 路径必须对应你系统实际的：

   - Java 路径：`/athena/jdk/jdk1.8.0_371/bin/java`
   - Jenkins war 包路径：`/usr/share/java/jenkins.war`（一般安装默认就是这个）

8. **重新加载 systemd 配置**：

   ```
   sudo systemctl daemon-reload
   sudo systemctl start jenkins
   ```

9.  启动 Jenkins 服务

   ```
   sudo systemctl start jenkins
   
   sudo systemctl restart jenkins
   ```

10. 检查运行状态

    ```
    sudo systemctl status jenkins
    ```

11.  打开浏览器访问 Jenkins

    ```
    http://129.28.122.208/:8080
    ```

## 🛠️Jenkins 与 Java 多版本共存配置

> - Jenkins 新版本要求 Java 17（或更高），而你的服务仍依赖 Java 8。
> - 可以在同一台服务器上共存 Java 8 和 Java 17，只需为 Jenkins 单独指定 Java 17 即可。
>

配置方式：

- **保留 Java 8 作为默认环境**（供业务服务使用）
- **为 Jenkins 专门使用 Java 17**

- 安装 Java 17

  ```
  sudo yum install java-17-openjdk -y
  ```

- 安装完成后可通过以下命令验证路径：

  ```
  readlink -f $(which java)
  ```

- 验证是否安装成功:

  ```
  /usr/lib/jvm/java-17-openjdk-17.0.6.0.9-0.3.ea.el8.x86_64/bin/java -version
  ```

🔢步骤 1：编辑 Jenkins 配置文件

```
sudo vi /etc/sysconfig/jenkins
```

添加以下内容（确保 Java 17路径正确）：

```
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.6.0.9-0.3.ea.el8.x86_64
JENKINS_JAVA_CMD="$JAVA_HOME/bin/java"
```

🔢步骤 2：编辑 Jenkins 的 systemd 启动文件

```
sudo vim /usr/lib/systemd/system/jenkins.service
```

```
🔍 找到这行（大概在文件中间）
ExecStart=/usr/bin/jenkins
Environment
```

把它修改为下面这样（**显式指定 Java 启动 Jenkins**）：

```
Environment="JENKINS_HOME=/var/lib/jenkins"
Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.6.0.9-0.3.ea.el8.x86_64"
ExecStart=/usr/lib/jvm/java-17-openjdk-17.0.6.0.9-0.3.ea.el8.x86_64/bin/java -jar /usr/share/java/jenkins.war
```

⚠️ 路径必须对应你系统实际的：

- Java 路径：`启动jenkins的java17的路径`
- Jenkins war 包路径：`/usr/share/java/jenkins.war`（一般安装默认就是这个）

🔢步骤 3：**重新加载 systemd 配置**

```
sudo systemctl daemon-reload
```

🔢步骤4：启动 Jenkins 服务

```
sudo systemctl start jenkins
```

✅ 效果：

- Jenkins 使用 Java 17，插件兼容性良好
- 你的应用服务继续使用 Java 8，互不干扰

## ⚙️ Jenkins 通过 Nginx 进行端口代理配置

✅ **Nginx 的主配置文件 `nginx.conf` 中，已经写好了一条“包含指令”**：

```
include /etc/nginx/conf.d/*.conf;
```

这个指令的作用是：

> 会自动加载 `/etc/nginx/conf.d/` 目录下的所有以 `.conf` 结尾的配置文件。

📌 这样做的好处是：你 **不需要去修改主配置文件 `nginx.conf`**，只需要：

- 在 `/etc/nginx/conf.d/` 目录下新建一个配置文件，例如：

```
/etc/nginx/conf.d/jenkins.conf
```

- 然后把你的 Jenkins 代理规则写在这个文件里就可以生效。

------

📝一、创建 Jenkins 的 Nginx 配置文件：

```
vim /etc/nginx/conf.d/jenkins.conf
```

在打开的文件中，粘贴如下配置：

❗将`你的服务器IP或域名`替换为实际使用的公网 IP 或域名。

```
server {
    listen 80;
    server_name 129.28.122.208;

    location / {
        proxy_pass http://localhost:8080/;
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;

        proxy_http_version 1.1;
        proxy_request_buffering off;
        proxy_buffering off;
        proxy_connect_timeout 300;
        proxy_send_timeout 300;
        proxy_read_timeout 300;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

```

🔍二、检查并重载 Nginx 配置：

```
nginx -t
# 如果提示OK，则重载Nginx配置
systemctl reload nginx
```

------

🚀三、开启防火墙端口

若防火墙开启，确保放行 HTTP（8081端口）：

```
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
```

------

🔍四、验证是否生效

```
访问：http://129.28.122.208:8081/login?from=%2F
```

## 🛠️ Jenkins 解锁与初始化配置

🔑 **解锁 Jenkins 的步骤：**

- > 第一次安装并启动 Jenkins 时，会出现 **「Unlock Jenkins」** 的页面，需要完成以下步骤

🚩 **1. 找到初始密码文件：**

- Jenkins 默认的初始密码位置为：

```
/var/lib/jenkins/secrets/initialAdminPassword
```

使用 SSH 登录到服务器，然后执行：

```
cat /var/lib/jenkins/secrets/initialAdminPassword
```

------

🚩 **2. 输入密码解锁 Jenkins：**

- 打开你的 Jenkins 页面：

```
http://129.28.122.208:8081
```

- 在提示框输入上面获取的初始密码并提交。

------

🚩 **3. 安装插件与创建管理员账户：**

- 解锁后 Jenkins 会提示你选择插件安装方式：

  - 推荐选择：
    - **Install suggested plugins（推荐插件）**
       系统自动安装常用插件，适合新手。

- 插件安装完成后，Jenkins 会要求你设置管理员账户和密码： root/123456

  | 字段             | 说明                 |
  | ---------------- | -------------------- |
  | Username         | 管理员用户名         |
  | Password         | 管理员密码（自定义） |
  | Confirm Password | 再次输入密码确认     |
  | Full name        | 姓名                 |
  | E-mail           | 邮箱地址（用于通知） |

------

🚩 **4. 完成配置：**

- 配置完成后点击保存，即可成功进入 Jenkins 主界面。

------



