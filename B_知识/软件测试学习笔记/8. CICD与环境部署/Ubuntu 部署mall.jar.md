## 🧱 一、首次启动（后台运行）

```
cd /home/ubuntu/mall
nohup java -jar tuling-admin-0.0.1-SNAPSHOT.jar > tuling-admin.log 2>&1 &
```

> 说明：
>
> - `nohup`：让程序在后台运行
> - `> tuling-admin.log`：保存输出日志
> - `2>&1`：包含错误输出
> - `&`：后台执行

### ✅ 查看是否启动成功：

```
ps -ef | grep tuling-admin
```

你会看到类似：

```
ubuntu  12345  1  0 23:20 ? 00:00:03 java -jar tuling-admin-0.0.1-SNAPSHOT.jar
```

------

## 🛑 二、停止程序

你有两种方式：

### 精确停止：

```
kill -9 12345
```

### 推荐方式（更安全）：

```
pkill -f tuling-admin-0.0.1-SNAPSHOT.jar
```

------

## 🔁 三、重新启动程序

```
cd /home/ubuntu/mall
pkill -f tuling-admin-0.0.1-SNAPSHOT.jar
sleep 3
nohup java -jar tuling-admin-0.0.1-SNAPSHOT.jar > tuling-admin.log 2>&1 &
```

------

## 📜 四、查看日志

实时查看运行日志：

```
tail -f /home/ubuntu/mall/tuling-admin.log
```

查看最后 100 行：

```
tail -n 100 /home/ubuntu/mall/tuling-admin.log
```

------

## ⚙️ 五、配置开机自启（推荐生产环境使用）

### 1️⃣ 创建 systemd 服务文件

```
sudo nano /etc/systemd/system/tuling-admin.service
```

写入以下内容 👇（路径和用户已替换为你的实际情况）：

```
[Unit]
Description=Tuling Admin Spring Boot Service
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/mall
ExecStart=/usr/bin/java -jar /home/ubuntu/mall/tuling-admin-0.0.1-SNAPSHOT.jar
SuccessExitStatus=143
Restart=always
RestartSec=10
StandardOutput=file:/home/ubuntu/mall/tuling-admin.log
StandardError=file:/home/ubuntu/mall/tuling-admin-error.log

[Install]
WantedBy=multi-user.target
```

保存退出（`Ctrl + O` → `Enter` → `Ctrl + X`）

------

### 2️⃣ 刷新 systemd 配置

```
sudo systemctl daemon-reload
```

### 3️⃣ 启动服务

```
sudo systemctl start tuling-admin
```

### 4️⃣ 查看运行状态

```
sudo systemctl status tuling-admin
```

若输出中有：

```
Active: active (running)
```

✅ 表示运行成功。

------

### 5️⃣ 设置开机自启

```
sudo systemctl enable tuling-admin
```

------

### 6️⃣ 管理命令汇总表

| 操作     | 命令                                                |
| ------ | ------------------------------------------------- |
| 启动     | `sudo systemctl start tuling-admin`               |
| 停止     | `sudo systemctl stop tuling-admin`                |
| 重启     | `sudo systemctl restart tuling-admin`             |
| 查看状态   | `sudo systemctl status tuling-admin`              |
| 实时日志   | `journalctl -u tuling-admin -f`                   |
| 查看过去日志 | `journalctl -u tuling-admin --since "10 min ago"` |
| 设置开机自启 | `sudo systemctl enable tuling-admin`              |
| 禁止开机自启 | `sudo systemctl disable tuling-admin`             |

------

## 🧾 六、快速脚本（可选）

如果你想手动管理，可以在 `/home/ubuntu/mall` 下创建一个管理脚本：

```
nano /home/ubuntu/mall/tuling.sh
```

内容如下：

```
#!/bin/bash
APP_NAME="tuling-admin-0.0.1-SNAPSHOT.jar"
APP_PATH="/home/ubuntu/mall"
LOG_FILE="$APP_PATH/tuling-admin.log"

cd $APP_PATH

case "$1" in
    start)
        echo "Starting $APP_NAME..."
        nohup java -jar $APP_PATH/$APP_NAME > $LOG_FILE 2>&1 &
        ;;
    stop)
        echo "Stopping $APP_NAME..."
        pkill -f $APP_NAME
        ;;
    restart)
        echo "Restarting $APP_NAME..."
        pkill -f $APP_NAME
        sleep 3
        nohup java -jar $APP_PATH/$APP_NAME > $LOG_FILE 2>&1 &
        ;;
    status)
        ps -ef | grep $APP_NAME | grep -v grep
        ;;
    log)
        tail -f $LOG_FILE
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|log}"
        ;;
esac
```

赋予执行权限：

```
chmod +x /home/ubuntu/mall/tuling.sh
```

使用：

```
./tuling.sh start
./tuling.sh stop
./tuling.sh restart
./tuling.sh status
./tuling.sh log
```

------

## ✅ 七、总结速查表

| 功能              | 命令                                                         |
| ----------------- | ------------------------------------------------------------ |
| 启动（后台）      | `nohup java -jar /home/ubuntu/mall/tuling-admin-0.0.1-SNAPSHOT.jar > /home/ubuntu/mall/tuling-admin.log 2>&1 &` |
| 查找进程          | `ps -ef                                                      |
| 停止进程          | `pkill -f tuling-admin-0.0.1-SNAPSHOT.jar`                   |
| 查看日志          | `tail -f /home/ubuntu/mall/tuling-admin.log`                 |
| 重启服务          | `pkill -f tuling-admin-0.0.1-SNAPSHOT.jar && nohup java -jar /home/ubuntu/mall/tuling-admin-0.0.1-SNAPSHOT.jar > /home/ubuntu/mall/tuling-admin.log 2>&1 &` |
| 创建 systemd 服务 | `/etc/systemd/system/tuling-admin.service`                   |
| 启动 systemd 服务 | `sudo systemctl start tuling-admin`                          |
| 设置开机自启      | `sudo systemctl enable tuling-admin`                         |

------

