### Jenkins 安装文档

------

#### 1. 安装 Java 11

Jenkins 需要 Java 运行时环境 (JRE)，因此首先需要安装 JDK 11。

```
sudo apt update
sudo apt install openjdk-11-jdk
```

确保 Java 11 安装成功：

```
java -version
```

------

#### 2. 下载 Jenkins WAR 文件

下载 Jenkins 的稳定版本 WAR 文件：

```
sudo wget https://get.jenkins.io/war-stable/2.387.2/jenkins.war -O /usr/share/java/jenkins.war
```

如果下载出现问题（如 404 错误），尝试使用不同的镜像源或手动下载。

------

#### 3. 创建 systemd 服务文件

创建一个 systemd 服务文件以便 Jenkins 在系统启动时自动运行。

```
sudo nano /etc/systemd/system/jenkins.service
```

在文件中粘贴以下内容，确保使用 JDK 11：

```
[Unit]
Description=Jenkins Automation Server
After=network.target

[Service]
ExecStart=/usr/lib/jvm/java-11-openjdk-amd64/bin/java -jar /usr/share/java/jenkins.war
User=jenkins
Group=jenkins
Restart=always
LimitNOFILE=8192

[Install]
WantedBy=multi-user.target
```

然后重新加载 systemd 配置，使服务生效：

```
sudo systemctl daemon-reload
```

------

#### 4. 启动 Jenkins 服务

启动 Jenkins 服务，并确保它在系统启动时自动启动：

```
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

------

#### 5. 查看 Jenkins 服务状态

查看 Jenkins 服务是否正在运行：

```
sudo systemctl status jenkins
```

如果 Jenkins 正常启动，输出应显示 `Active: active (running)` 状态。

------

#### 6. Jenkins 初始设置

首次启动 Jenkins 时，需要进行初始设置。你会看到类似以下的信息：

```
Jenkins initial setup is required. An admin user has been created.
Please use the following password to proceed to installation:
675d821c7328436098a11913b7be0742
This may also be found at: /var/lib/jenkins/.jenkins/secrets/initialAdminPassword
```

你可以通过以下命令获取该初始密码：

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

复制密码并粘贴到 Jenkins 安装界面的解锁框中。

------

#### 7. 访问 Jenkins

在浏览器中访问 Jenkins Web 界面：

```
http://<your-server-ip>:8080
```

使用上述步骤中的密码解锁 Jenkins，按照向导完成安装和配置。

------

#### 8. 遇到的问题和规避措施

- **Java 版本问题**：确保使用 JDK 11 来启动 Jenkins。如果没有正确设置 `ExecStart`，Jenkins 可能无法启动。
- **下载链接问题**：如果下载 Jenkins WAR 文件时遇到 404 错误，尝试使用不同的镜像源（如 `https://mirror.twds.com.tw`），或者手动下载 WAR 文件并放置在指定路径。
- **服务启动问题**：确保 `systemd` 配置正确。使用 `sudo systemctl status jenkins` 检查服务状态，若有错误，查看日志以进行排查。

如果未来遇到类似问题，可以通过检查 `systemctl status jenkins` 和 `journalctl -u jenkins` 来查看日志和错误信息。