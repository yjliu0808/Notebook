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

### 安装mysql8.0操作步骤

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

```
export MAVEN_HOME=/athena/maven/apache-maven-3.9.6
export PATH=$PATH:$MAVEN_HOME/bin

```



### 安装redis操作步骤

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

```
/usr/share/nginx/html/dist   将打包好的dist文件上传即可
```



### 开启自启jar包服务

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

###  CentOS Stream 系统中安装 Jenkins（兼容 JDK 1.8 环境）

#### 1、添加 Jenkins 源仓库

成功从 Jenkins 官方下载了 `jenkins.repo` 文件
并保存到了 `/etc/yum.repos.d/` 目录中（这个目录是系统用来存放所有 YUM 仓库配置的地方）

```
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
```

#### 2、从 Jenkins 官网手动下载 **指定版本的 Jenkins 主程序（.war 包）**，保存到系统指定路径中。

```
sudo wget -O /usr/share/java/jenkins.war https://get.jenkins.io/war-stable/2.346.3/jenkins.war
```

📢 Jenkins 2.346.3 是最后一个支持 Java 8 的 **LTS 稳定版**

#### 3、Jenkins 安装前 GPG Key 操作顺序（适配 `jenkins.io-2023.key`）

#### 1️⃣ **先下载 Jenkins 官方 GPG key**

```
curl -O https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

------

#### 2️⃣ **手动导入 GPG key 到系统（rpm 信任 key 环）**

```
sudo rpm --import jenkins.io-2023.key
```

------

#### 3️⃣ **编辑 Jenkins 的 YUM 源配置文件**

```
sudo vi /etc/yum.repos.d/jenkins.repo
```

内容如下（关键是要指向你刚才导入的那把 key）：

```
ini复制编辑[jenkins]
name=Jenkins-stable
baseurl=https://pkg.jenkins.io/redhat-stable
gpgcheck=1
gpgkey=https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

------

#### 4️⃣ **清缓存 & 更新源（防止历史影响）**

```
sudo yum clean all
sudo rm -rf /var/cache/yum
sudo yum makecache
```

------

#### 5️⃣ **安装 Jenkins（会校验 GPG 签名）**

```
sudo yum install -y jenkins
```

#### ✏️ 步骤 1：编辑 Jenkins 配置文件

```
sudo vi /etc/sysconfig/jenkins

```

添加以下内容（确保 Java 8 路径正确）：

```
JAVA_HOME=/athena/jdk/jdk1.8.0_371
JENKINS_JAVA_CMD="$JAVA_HOME/bin/java"

```

#### ✏️步骤 2：编辑 Jenkins 的 systemd 启动文件

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

**重新加载 systemd 配置**：

```

sudo systemctl daemon-reload
sudo systemctl start jenkins
```

#### 1️⃣ 启动 Jenkins 服务

```
sudo systemctl start jenkins

sudo systemctl restart jenkins

```

------

#### 3️⃣ 检查运行状态

```
sudo systemctl status jenkins
```

如果看到状态是 `active (running)` 就代表 Jenkins 启动正常！

------

#### 4️⃣ 打开浏览器访问 Jenkins

```
http://129.28.122.208/:8080
```

### Jenkins 通过 Nginx 进行端口代理的步骤如下

#### 推荐的 Jenkins 代理配置方案：

现有的`nginx.conf`已经包含了：

```
include /etc/nginx/conf.d/*.conf;
```

因此不需要修改主配置文件，**只需额外创建一个 Jenkins 专用配置文件即可**。

------

#### 一、创建 Jenkins 的 Nginx 配置文件：

执行：

```
vim /etc/nginx/conf.d/jenkins.conf
```

在打开的文件中，粘贴如下配置：

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

注意：

- 将`你的服务器IP或域名`替换为实际使用的公网 IP 或域名。

------

#### 二、检查并重载 Nginx 配置：

执行命令：

```
nginx -t

# 如果提示OK，则重载Nginx配置
systemctl reload nginx
```

------

#### 三、开启防火墙端口（如有必要）：

若防火墙开启，确保放行 HTTP（80端口）：

```
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
```

------

#### 四、验证是否生效：

浏览器访问：

```
http://129.28.122.208:8081/login?from=%2F
```

即可访问 Jenkins 服务。

### jenkins配置

#### 🔑 **解锁 Jenkins 的步骤：**

你第一次安装并启动 Jenkins 时，会出现 **「Unlock Jenkins」** 的页面，需要完成以下步骤：

------

#### 🚩 **1. 找到初始密码文件：**

- Jenkins 默认的初始密码位置为：

```
/var/lib/jenkins/secrets/initialAdminPassword
```

使用 SSH 登录到服务器，然后执行：

```
cat /var/lib/jenkins/secrets/initialAdminPassword
```

------

#### 🚩 **2. 输入密码解锁 Jenkins：**

- 打开你的 Jenkins 页面：

```
http://129.28.122.208:8081
```

- 在提示框输入上面获取的初始密码并提交。

------

#### 🚩 **3. 安装插件与创建管理员账户：**

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

#### 🚩 **4. 完成配置：**

- 配置完成后点击保存，即可成功进入 Jenkins 主界面。

## 升级 Jenkins 到最新版（适用于 `.war` 启动方式）

你当前 Jenkins 是通过手动下载 `.war` 包启动的，对吧？路径在：

```

/usr/share/java/jenkins.war
```

那升级就超简单 —— **只要下载新版 `.war` 替换掉旧文件**！

------

#### ✅ 步骤一：备份当前 Jenkins `.war`（保险一点）

```

sudo cp /usr/share/java/jenkins.war /usr/share/java/jenkins.war.bak
```

------

#### ✅ 步骤二：下载最新版 Jenkins `.war`

```

sudo wget -O /usr/share/java/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war
```

或者指定具体 LTS 版本（比如 2.426.3）：

```
sudo wget -O /usr/share/java/jenkins.war https://get.jenkins.io/war-stable/2.426.3/jenkins.war
```

------

#### ✅ 步骤三：重启 Jenkins 服务

```
sudo systemctl restart jenkins
```

------

#### ✅ 步骤四：验证升级成功

打开浏览器访问 Jenkins：

```
http://129.28.122.208:8081
```

在右下角或系统信息里查看 Jenkins 版本，确认是最新的。

- 

  ### Jenkins 与 Java 多版本共存配置

  #### 背景：

  - Jenkins 新版本要求 Java 17（或更高），而你的服务仍依赖 Java 8。
  - 可以在同一台服务器上共存 Java 8 和 Java 17，只需为 Jenkins 单独指定 Java 17 即可。

  #### 配置方式：

  1. **保留 Java 8 作为默认环境**（供业务服务使用）：

  编辑 `/etc/profile` 或 `~/.bash_profile`：

  ```
  export JAVA_HOME=/athena/jdk/jdk1.8.0_371
  export PATH=$JAVA_HOME/bin:$PATH
  ```

  1. **为 Jenkins 专门使用 Java 17**：

  - 安装 Java 17

    ```
    sudo yum install java-17-openjdk -y
    ```

  - 安装完成后可通过以下命令验证路径：

    ```
    readlink -f $(which java)
    ```

    

  - 安装路径通常在：`/usr/lib/jvm/java-17-openjdk-17.0.6.0.9-0.3.ea.el8.x86_64/bin/java 你可以验证是否安装成功：

  ```
  
  /usr/lib/jvm/java-17-openjdk-17.0.6.0.9-0.3.ea.el8.x86_64/bin/java -version
  ```

  #### 步骤 1：编辑 Jenkins 配置文件

  ```
  sudo vi /etc/sysconfig/jenkins
  
  ```

  添加以下内容（确保 Java 17路径正确）：

  ```
  JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.6.0.9-0.3.ea.el8.x86_64
  JENKINS_JAVA_CMD="$JAVA_HOME/bin/java"
  
  
  ```

  #### ✏️步骤 2：编辑 Jenkins 的 systemd 启动文件

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

  **重新加载 systemd 配置**：

  ```
  sudo systemctl daemon-reload
  
  ```

  #### 1️⃣ 启动 Jenkins 服务

  ```
  sudo systemctl start jenkins
  ```

  #### ✅ 效果：

  - Jenkins 使用 Java 17，插件兼容性良好
  - 你的应用服务继续使用 Java 8，互不干扰

### jenkins 集成github

以下是在 CentOS Stream 系统中，使用 Jenkins 和 GitHub 实现 CI/CD 流水线的详细操作步骤：

#### 一、Jenkins 配置

##### 1. 安装必要插件

打开 Jenkins 控制台 → "Manage Jenkins" → "Manage Plugins" 安装以下插件：

- Git
- GitHub
- Pipeline
- Publish Over SSH（如果涉及部署）
- allure

#### 二、环境准备

1. 安装 Jenkins（假设已安装）
2. 安装 Git、Maven、JDK 到系统里

##### ✅ 1. 安装 Git

```
sudo yum install git -y
which git  # 验证路径，一般是 /usr/bin/git
```

------

##### ✅ 2. 安装 JDK（比如 Java 8）

如果你已经手动解压了 Java 8，比如放在 `/athena/jdk/jdk1.8.0_371`，就直接记住路径即可。

------

##### ✅ 3. 安装 Maven

```
cd /athena/maven
sudo wget https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
tar -zxvf apache-maven-3.8.6-bin.tar.gz
# 安装路径就是 /athena/maven/apache-maven-3.8.6
```

------

##### ✅ 4. 安装 allure

```
# 使用 wget 工具从 GitHub 下载 Allure 安装包
cd /athena/allure
wget https://github.com/allure-framework/allure2/releases/download/2.27.0/allure-2.27.0.tgz
#或者官方下载地址：https://github.com/allure-framework/allure2/releases/tag/2.27.0
```

##### **✅ 1. 然后再进入 Jenkins 控制台进行配置**

路径：**Manage Jenkins → Global Tool Configuration**全局工具配置

在页面中配置：

##### ✅ 2. Git 工具配置：

- 名称：`Default Git`
- Path to Git executable：`/usr/bin/git`

##### ✅ 3. JDK 配置：

- 名称：`jdk8`
- JAVA_HOME：`/athena/jdk/jdk1.8.0_371`
- 取消勾选 “Install automatically”

##### ✅ 4.  Maven 配置：

- 名称：`maven-3.8.6`
- MAVEN_HOME：`/opt/apache-maven-3.8.6`
- 取消勾选 “Install automatically”

##### ✅ 4.  Allure 配置：

- 名称：`allure`
- MAVEN_HOME：`/athena/allure2.7.0`
- 取消勾选 “Install automatically”

配置后点击页面最下方的保存 ✅

------

##### ✅ 总结一句话：

> Jenkins 不安装这些工具本身，只是**引用系统里已有的 Git、JDK、Maven**，你必须先安装好它们，Jenkins 才能调用。



#### 三、配置 GitHub 认证

##### ✅ 一、在 GitHub 上创建访问令牌（Token）

1. 登录你的 GitHub 账号

2. 点击右上角头像 → **Settings**

3. 进入左侧栏 → **Developer settings**

4. 点击左侧 **Personal access tokens** → **Tokens (classic)**

5. 点击按钮：**Generate new token (classic)**

6. 填写信息：

   - **Note**：例如 `jenkins-token`

   - **Expiration**：建议选择 `90 days` 或 `No expiration`

   - **Scopes 权限勾选**：

     ```
     ✅ repo              # 访问私有仓库
     ✅ admin:repo_hook   # 设置 Webhook
     ✅ read:org          # 读取组织信息（如果是团队仓库）
     ```

7. 创建完成后，复制这段 Token，一定要保存（只显示一次）
   


------

##### ✅ 二、在 Jenkins 中配置 GitHub 凭据

1. 打开 Jenkins → `Manage Jenkins` → `Manage Credentials`
2. 点击左侧的 `Stores scoped to Jenkins` → `System` → `Global credentials (unrestricted)`
   系统管理->凭据->系统->全局凭据 (unrestricted)
3. 点击右侧 `Add Credentials`
4. 填写如下：

| 字段        | 填写内容                         |
| ----------- | -------------------------------- |
| Kind        | `Secret text`                    |
| Secret      | 粘贴你的 GitHub token            |
| ID（可选）  | `github-token`（你也可以自定义） |
| Description | `GitHub Personal Access Token`   |

------

#### 四、jenkins实现自动部署

##### 📦 第一步：你本地创建 Maven 项目 + 上传到 GitHub

1. 本地创建一个标准的 Maven 项目（有 `pom.xml`）

2. 在根目录下加上 `Jenkinsfile`（用于描述构建过程）和pom.xml文件同一目录下。
   Jenkinsfile文件内容如下：

   ```
   pipeline {
       agent any
   
       tools {
           maven 'maven3.8.6'
           jdk 'jdk1.8'
       }
   
       environment {
           MAVEN_OPTS = '-Xmx1024m'
       }
   
       triggers {
           githubPush()
           // pollSCM('@daily') // 可选：每日定时拉取（备用兜底）
       }
   
       stages {
           stage('🧪 Checkout') {
               steps {
                   echo '🔄 拉取代码中...'
                   checkout scm
               }
           }
   
           stage('🔧 Build & Test') {
               steps {
                   echo '🧪 开始执行自动化测试...'
                   // 显式指定 bash，避免 sh 不兼容问题
                   sh 'bash -c "mvn clean test"'
                   // 收集单元测试报告，展示到 Jenkins UI
                   junit '**/target/surefire-reports/*.xml'
               }
           }
   
           stage('📊 生成 Allure 报告') {
               steps {
                   script {
                       try {
                           echo '📊 准备展示 Allure 测试报告...'
                           sh 'ls -l target/allure-results || echo "❗ 未生成 Allure 结果文件"'
                           allure([
                               includeProperties: false,
                               results: [[path: 'target/allure-results']]
                           ])
                       } catch (Exception e) {
                           echo "⚠️ Allure 报告生成失败：${e.message}"
                       }
                   }
               }
           }
   
           stage('📦 归档构建产物（可选）') {
               when {
                   expression { fileExists('target') }
               }
               steps {
                   echo '📦 归档 jar 包或其他产物...'
                   archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
               }
           }
       }
   
       post {
           always {
               echo '🧹 构建结束，执行收尾操作...'
               archiveArtifacts artifacts: '**/target/allure-results/**', allowEmptyArchive: true
           }
   
           success {
               echo '✅ 构建成功！'
           }
   
           failure {
               echo '❌ 构建失败，请检查 Jenkinsfile、网络或测试代码。'
           }
       }
   }
   
   ```

   

3. 初始化 git 仓库并推送到 GitHub

   ```
   git init
   #先在 GitHub 上新建一个空仓库，比如叫：api_auto_mall_v1.5test
   git remote remove origin
   git remote add origin https://github.com/yjliu0808/api_auto_mall_v1.5test.git
   git add .
   git commit -m "init"
   git push -u origin main
   ```

------



##### 🚀 第二步：在 Jenkins 中创建一个流水线任务，让它自动拉取 GitHub 代码

1. 打开 Jenkins → 【新建任务】 → 输入名称 → 类型选择 `流水线（Pipeline）`也适用maven类型项目

2. 配置如下：

   - **定义方式**：选择 `Pipeline script from SCM`

   - **SCM**：选择 `Git`

   - **Repository URL**：填写你的 GitHub 仓库地址

   - **Credentials**：新增用户密码的凭据

   - **Branch**：填写 `main` 或你的开发分支

   - **Script Path**：默认 `Jenkinsfile`，如果不是根目录也可以自定义路径

     

------

##### 🚀 第三步、HTTPS 克隆 GitHub 仓库，**请这样添加凭据**

1. Jenkins → 凭据 → 全局（global）
2. 添加新凭据
3. 类型：`用户名和密码`
4. 填写：
   - 用户名：你的 GitHub 用户名
   - 密码：你的 GitHub Token（PAT）
   - ID：比如 `github-https`

然后回到你的项目配置里，Git 凭据下拉中就能选到它 ✅

##### 🔁 第四步（推荐）：配置 GitHub Webhook 实现自动触发 Jenkins

> 这样每次你 `git push`，Jenkins 就能自动拉取并构建！

在 GitHub 项目中配置 Webhook：

1. 进入具体项目 仓库 → 【Settings】

2. 点击左侧【Webhooks】 → Add webhook

3. 配置如下：

   - **Payload URL**：

     ```
     http://129.28.122.208:8081/github-webhook/
     ```
     
   - **Content type**：`application/json`

   - **事件选择**：默认 `Just the push event` 即可

   - **Secret** 可不填（后期增强安全性时使用）

4. 点击【Add webhook】

5. 配置完成验证方式：

   Webhooks模块内：点击链接进去详情：有[Recent Deliveries](https://github.com/yjliu0808/api_auto_mall_v1.5test/settings/hooks/540042535?tab=deliveries)可以查看是否有push记录

------

##### ✅ 整体流程总结图

```
本地提交代码
      ↓ push
GitHub 触发 Webhook
      ↓
Jenkins 接收到通知
      ↓
自动拉取最新代码（Git）
      ↓
执行 Jenkinsfile 中定
```

# Jenkins GitHub Push 自动触发构建问题排查总结

## ✅ 问题背景

通过 GitHub Push 自动触发 Jenkins 构建失败，最终通过排查与配置修复完成。

------

## 🧩 问题总结

### 1. Git 命令无响应

- **现象**：服务器执行 `git status` 无反应。
- **操作**：重新安装了 Git，确保可正常执行 Git 命令。
- **原因分析**：系统中的 Git 工具可能损坏或未完整安装，导致 Jenkins 在拉取代码时挂起。

### 2. 仓库地址使用 SSH 协议

- **配置项**：Repository URL 设置为：

  ```
  git@github.com:yjliu0808/TESTCICD.git
  ```

- **注意事项**：

  - 必须确保 Jenkins 服务器上的 `jenkins` 用户拥有访问该地址的权限。
  - 需信任 GitHub 的 SSH Host Key。

### 3. Jenkins SSH 凭据配置错误

- **尝试方式**：
  - 用户名 + 密码：❌（403 错误）
  - 用户名 + 私钥文件路径：❌（Jenkins 无法识别文件路径）
  - SSH Username with private key + 粘贴服务器私钥：✅
- **最终成功配置**：
  - 类型：`SSH Username with private key`
  - ID：`github-ssh`
  - Username：`git`
  - Private Key：复制粘贴 Jenkins 用户目录下 `.ssh/id_rsa` 私钥内容

#### 🔐 如何生成并使用 SSH 密钥：

1. **切换到 jenkins 用户**：

   ```bash
   sudo su - jenkins
   ```

2. **生成密钥对**：

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   # 一路回车即可，生成文件默认在 ~/.ssh/id_rsa 和 id_rsa.pub
   ```

3. **配置 GitHub 公钥**：

   - 登录 GitHub → Settings → SSH and GPG keys → New SSH key
   - Title 可随意，粘贴 `~/.ssh/id_rsa.pub` 内容

4. **复制私钥添加到 Jenkins**：

   - 查看私钥：

     ```bash
     cat ~/.ssh/id_rsa
     ```

   - 在 Jenkins Credentials 添加新凭据：

     - 类型：SSH Username with private key
     - Username：`git`
     - Private Key：选择 “Enter directly”，粘贴上述私钥内容

### 4. 首次构建需手动触发

- **现象**：Push 后无响应，但 Webhook 收到请求
- **操作**：首次点击 Jenkins 页面上的 `Build Now` 执行一次手动构建
- **原因分析**：首次构建后 Jenkins 会初始化流水线上下文，此后才可被 Push 自动触发

------

## 📄 关键配置项确认清单

-  Git 已正确安装并在系统中可用
-  Jenkins 项目中使用 SSH 地址进行仓库连接
-  Jenkins Credentials 中添加了 SSH 凭据并关联
-  Jenkinsfile 中包含 `triggers { githubPush() }`
-  项目勾选 `GitHub hook trigger for GITScm polling`
-  GitHub Webhook 指向 Jenkins 地址（如：http://<your_ip>:8080/github-webhook/）
-  Jenkins 用户可通过 SSH 成功连接 GitHub：`ssh -T git@github.com`
-  **首次构建需在 Jenkins 中手动点击 Build Now 初始化**

------

## 🔁 推荐操作流程

1. 确保服务器 Git 安装正常：`git --version`
2. 在服务器生成 SSH 密钥对，并配置到 GitHub
3. 将 SSH 私钥添加到 Jenkins Credentials
4. Jenkins 项目配置使用该 SSH 凭据并填写 SSH 仓库地址
5. Jenkinsfile 中加上 `githubPush()` 触发器
6. 项目勾选 `GitHub hook trigger for GITScm polling`
7. GitHub 仓库添加 webhook 指向 Jenkins 地址
8. **首次进入 Jenkins 页面点击一次 `Build Now` 执行构建**

------

## ✅ 最终结果

- GitHub Push 可成功触发 Jenkins 构建
- Jenkins 拉取仓库成功并执行流水线
- 自动化流程配置完成，稳定运行

------

文档生成时间：2025-04-13
 文档作者：用户 + ChatGPT 联合调试产出 ✅

# Jenkins + GitHub CI/CD: 测试简单 mall 项目实现 CI/CD

## 项目目标

通过 Jenkins 实现 GitHub Push 触发构建、测试、部署 mall 项目的基础 CI/CD 流程。

------

## 1. 前置准备

### 服务器环境

- CentOS Stream
- Git 2.43+
- Jenkins (Java 8 环境)
- SSH 已配置成功连接 GitHub

### 项目仓库

- 新建仓库地址: `git@github.com:yjliu0808/SimplePerfMall.git`
- 包含 Jenkinsfile 用于指定 CI/CD 流程

### GitHub Webhook 配置

- URL: `http://129.28.122.208:8081/github-webhook/`
- Content-Type: application/json
- 仅选 push 事件

------

## 2. Jenkins 中新建 Job

### 类型选择

- 选择 "Pipeline"

### General

- 名称: mall
- 勾选 "GitHub project" 并填写项目 URL

### Source Code Management

- Git
  - Repository URL: `git@github.com:yjliu0808/mall.git`
  - Credentials: 使用配置好的 SSH private key

### Build Triggers

-  GitHub hook trigger for GITScm polling

### Pipeline

- Definition: Pipeline script from SCM
  - SCM: Git
  - Repository URL: `git@github.com:yjliu0808/mall.git`
  - Credentials: github-ssh
  - Branches to build: */main
  - Script Path: Jenkinsfile

------

## 3. Jenkinsfile 示例

```groovy
pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {
        stage('Build') {
            steps {
                echo '🏗 构建正在执行...'
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Test') {
            steps {
                echo '🧪 正在执行单元测试...'
                sh 'mvn test'
            }
        }

        stage('Deploy') {
            steps {
                echo '🚀 正在部署...'
                // 可选扩展部署命令
            }
        }
    }
}
```

------

## 4. 首次构建注意

- 第一次 push 后无效触发 CI/CD
- 需手动在 Jenkins UI 中点击 `Build Now`
- 执行成功后前置上下文初始化，后续 push 即可自动构建

------

## 5. CI/CD 结果

- GitHub push 成功触发 Jenkins
- 项目按照 Jenkinsfile 完成构建、测试、部署
- 基础版 mall 项目自动化流程配置完成

------

文档生成时间：2025-04-13
 文档编辑：用户 + ChatGPT 合作产出
