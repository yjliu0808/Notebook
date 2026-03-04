## ✅ 一、彻底清除系统中旧的 Java 版本

```
sudo apt purge openjdk-* -y
sudo apt autoremove -y
sudo apt autoclean
```

------

## ☕ 二、安装 OpenJDK 8（JDK 1.8）

```
sudo apt update
sudo apt install openjdk-8-jdk -y
```

------

## 🔍 三、验证安装

```
java -version
javac -version
```

正常输出示例：

```
openjdk version "1.8.0_402"
OpenJDK Runtime Environment (build 1.8.0_402-8u402-ga)
OpenJDK 64-Bit Server VM (build 25.402-b02, mixed mode)
```

------

## ⚙️ 四、设置环境变量（让 JAVA_HOME 永久生效）

```
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' | sudo tee /etc/profile.d/java8.sh
echo 'export PATH=$JAVA_HOME/bin:$PATH' | sudo tee -a /etc/profile.d/java8.sh
source /etc/profile.d/java8.sh
```

验证：

```
echo $JAVA_HOME
```

输出应为：

```
/usr/lib/jvm/java-8-openjdk-amd64
```

------

## ✅ 五、确认系统只识别 JDK 1.8

```
sudo update-alternatives --display java
```

若仅显示 `/usr/lib/jvm/java-8-openjdk-amd64/...`，
 说明系统中确实只存在 JDK 8。

------

## 🔒 六、一键检查总结

```
java -version
echo $JAVA_HOME
```

输出正确即可。

