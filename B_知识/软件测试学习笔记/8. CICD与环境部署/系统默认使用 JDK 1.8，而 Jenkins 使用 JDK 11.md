## **目标：**

- **系统默认使用 JDK 1.8**。
- **Jenkins 使用 JDK 11**。

### **步骤 1：设置系统默认 Java 版本为 JDK 1.8**

1️⃣ **确认系统中安装了 JDK 1.8 和 JDK 11**         未安装请参考：[[JDK 1.8安装 (Ubuntu 24.04 专用)]]

首先确认你已经安装了 **JDK 1.8** 和 **JDK 11**。你可以通过以下命令来检查：

```
java -version
```

如果当前不是 **JDK 1.8**，请继续进行下面的步骤。

2️⃣ **设置系统默认 Java 版本为 JDK 1.8**

使用 `update-alternatives` 命令来选择默认的 Java 版本：

```
sudo update-alternatives --config java
```

你将看到类似下面的输出：

```
There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                         Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-11-openjdk-amd64/bin/java   1111      auto mode
  1            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java  1081      manual mode
```

- 输入 `1` 来选择 **JDK 1.8**，然后按 **Enter** 键。

3️⃣ **确认当前 Java 版本为 JDK 1.8**

执行以下命令确认 **JDK 1.8** 是系统当前使用的 Java 版本：

```
java -version
```

输出应为：

```
openjdk version "1.8.0_462"
OpenJDK Runtime Environment (build 1.8.0_462-8u462-ga~us1-0ubuntu2~24.04.2-b08)
OpenJDK 64-Bit Server VM (build 25.462-b08, mixed mode)
```

------

### **步骤 2：配置 Jenkins 使用 JDK 11**

1️⃣ **编辑 Jenkins 配置文件**

打开 Jenkins 启动配置文件 `/etc/default/jenkins`，通过以下命令编辑：

```
sudo nano /etc/default/jenkins
```

2️⃣ **设置 `JAVA_HOME` 为 JDK 11**

在文件中，找到 `JAVA_HOME` 配置项并将其修改为 **JDK 11** 的路径：

```
JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
```

3️⃣ **保存并退出**

按 `CTRL + X` 保存并退出（按 `Y` 确认，按 `Enter` 返回）。

------

### **步骤 3：重启 Jenkins 服务**

为使更改生效，重启 Jenkins 服务：

```
sudo systemctl restart jenkins
```

------

### **步骤 4：确认 Jenkins 使用 JDK 11**

1️⃣ **检查 Jenkins 服务状态**

确认 Jenkins 是否正常运行：

```
sudo systemctl status jenkins
```

2️⃣ **确认 Jenkins 使用的 Java 版本**

你可以通过查看 Jenkins 的启动日志来确认它使用了 **JDK 11**：

```
sudo journalctl -u jenkins | grep -i java
```

或者登录到 **Jenkins** 的 Web 界面，进入 **"Manage Jenkins" > "System Information"**，在 **Java** 部分查看当前 Jenkins 使用的 Java 版本，确保它是 **JDK 11**。

------

### **步骤 5：确认系统默认 Java 版本为 JDK 1.8**

1️⃣ **确认默认 Java 版本**

你可以再次执行以下命令来确保 **JDK 1.8** 是系统默认的 Java 版本：

```
java -version
```

输出应为 **JDK 1.8** 版本：

```
openjdk version "1.8.0_462"
OpenJDK Runtime Environment (build 1.8.0_462-8u462-ga~us1-0ubuntu2~24.04.2-b08)
OpenJDK 64-Bit Server VM (build 25.462-b08, mixed mode)
```

------

### **总结**

1. **系统默认使用 JDK 1.8**：
   - 使用 `sudo update-alternatives --config java` 来选择 **JDK 1.8** 作为系统默认 Java 版本。
2. **Jenkins 使用 JDK 11**：
   - 编辑 `/etc/default/jenkins` 文件，将 **`JAVA_HOME`** 设置为 **JDK 11** 的路径。
   - 重启 Jenkins 服务使其生效。
3. **确认 JDK 版本**：
   - 使用 `java -version` 和 Jenkins 日志确认系统和 Jenkins 的 Java 版本。

------

### **其他说明**

- 通过 `update-alternatives` 工具，系统中可以安装多个版本的 Java。该命令允许你灵活地在 **多个 JDK 版本** 之间切换。
- 你可以在 `/etc/default/jenkins` 中为 Jenkins 设置 **特定的 Java 环境**，而不影响系统其他软件的配置。

------

