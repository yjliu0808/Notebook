# 🧩 Ubuntu 24 Jenkins + Allure 安装与问题总结

> 本文记录了在 **Ubuntu 24.04 LTS** 环境下安装 Jenkins、配置 Java 环境、解决启动失败、以及安装 Allure 命令行工具的全过程与问题分析。  
> 环境：腾讯云 Ubuntu 24.04，用户 `ubuntu`，无桌面环境。

---

## 🚀 一、安装 Jenkins

### 1. 添加 Jenkins LTS 仓库与 GPG 密钥

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /etc/apt/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
```

### 2. 安装 Jenkins（最新 LTS 版本）

```
sudo apt install jenkins -y
```

📦 安装完成后默认文件位置：

- Jenkins 服务文件：`/etc/systemd/system/jenkins.service`
- Jenkins 数据目录：`/var/lib/jenkins`
- Jenkins 日志：`/var/log/jenkins/jenkins.log`

------

## ⚙️ 二、Java 环境管理

### 1. 安装多版本 Java（建议安装 8、11、17）

```
sudo apt install openjdk-8-jdk openjdk-11-jdk openjdk-17-jdk -y
```

### 2. 切换系统默认 Java 版本

```
sudo update-alternatives --config java
```

选择：

```
3  →  /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
```

验证：

```
java -version
```

输出：

```
openjdk version "1.8.0_462"
```

------

## 🧱 三、Jenkins 启动失败问题与修复

### ❌ 问题现象

执行：

```
sudo systemctl status jenkins
```

输出类似：

```
Running with Java 11 from /usr/lib/jvm/java-11-openjdk-amd64, which is older than the minimum required version (Java 17).
```

原因：

> Jenkins 2.528.2 版本要求 **最低 Java 17**。

------

### ✅ 修复方案

编辑 Jenkins 服务配置：

```
sudo vim /etc/systemd/system/jenkins.service
```

替换内容为：

```
[Unit]
Description=Jenkins Automation Server
After=network.target

[Service]
ExecStart=/usr/lib/jvm/java-17-openjdk-amd64/bin/java -jar /usr/share/java/jenkins.war
User=jenkins
Group=jenkins
Environment="JENKINS_HOME=/var/lib/jenkins"
Restart=always
LimitNOFILE=8192

[Install]
WantedBy=multi-user.target
```

然后执行：

```
sudo systemctl daemon-reload
sudo systemctl restart jenkins
sudo systemctl status jenkins
```

✅ 输出结果：

```
Active: active (running)
```

验证实际运行 Java：

```
ps -ef | grep jenkins | grep java
```

应显示：

```
/usr/lib/jvm/java-17-openjdk-amd64/bin/java
```

------

## 🧩 四、Allure 命令行安装

```
cd ~
mkdir allure && cd allure
sudo wget https://github.com/allure-framework/allure2/releases/download/2.34.0/allure-2.34.0.tgz
tar -zxvf allure-2.34.0.tgz
sudo mv allure-2.34.0 /opt/allure
sudo ln -s /opt/allure/bin/allure /usr/local/bin/allure
```

验证：

```
allure --version
```

输出：

```
2.34.0
```

------

## 📊 五、在 Jenkins 集成 Allure 报告

1. 在 Jenkins 插件中心搜索 **Allure Jenkins Plugin**

2. 安装后重启 Jenkins

3. 在构建项目中添加：

   ```
   Post-build Action → Allure Report
   Results path: allure-results
   ```

4. 构建完成后访问：

   ```
   http://your-server:8080/job/项目名/allure/
   ```

------

## 🧰 六、常见问题总结

| 问题                                              | 原因                  | 解决方式                                                     |
| ------------------------------------------------- | --------------------- | ------------------------------------------------------------ |
| `Package 'jenkins' has no installation candidate` | 未添加 Jenkins 官方源 | 按文档第1步添加源                                            |
| `jenkins.service: Failed with result 'exit-code'` | Java 版本过低         | 使用 Java 17                                                 |
| `allure: command not found`                       | 未创建符号链接        | 执行 `sudo ln -s /opt/allure/bin/allure /usr/local/bin/allure` |
| Jenkins 插件依赖报错                              | 核心版本太低          | 升级 Jenkins 至 2.528+                                       |
| 页面无法访问 8080 端口                            | 防火墙限制            | `sudo ufw allow 8080`                                        |

------

## 🧾 七、验证脚本（可选）

创建 `/usr/local/bin/check-jenkins-java.sh`：

```
#!/bin/bash
echo "System Java: $(java -version 2>&1 | head -n 1)"
echo "Jenkins Java: $(ps -ef | grep jenkins | grep java | awk '{print $8}')"
systemctl is-active --quiet jenkins && echo "Jenkins status: ✅ running" || echo "Jenkins status: ❌ stopped"
```

赋权并运行：

```
sudo chmod +x /usr/local/bin/check-jenkins-java.sh
check-jenkins-java.sh
```

------

## 🏁 八、最终结果

| 模块                  | 状态               |
| --------------------- | ------------------ |
| Jenkins 服务          | ✅ Active (running) |
| Jenkins Java          | ✅ Java 17          |
| 系统默认 Java         | ✅ Java 8           |
| Allure CLI            | ✅ 2.34.0           |
| Jenkins + Allure 集成 | ✅ 成功展示报告     |

------

🟢 **至此，Jenkins + Allure 环境在 Ubuntu 24 上已完全可用。**