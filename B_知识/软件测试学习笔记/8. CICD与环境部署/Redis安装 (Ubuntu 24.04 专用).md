## 🧩 一、更新系统软件源

```
sudo apt update
sudo apt upgrade -y
```

------

## 🧱 二、安装 Redis 服务

Ubuntu 24.04 官方仓库自带 Redis，可以直接安装：

```
sudo apt install redis-server -y
```

------

## ⚙️ 三、修改配置文件（让 Redis 支持远程访问）

Redis 默认只允许本地访问，如果你需要远程访问，请修改配置：

```
sudo nano /etc/redis/redis.conf
```

找到这一行：

```
bind 127.0.0.1 ::1
```

改为：

```
bind 0.0.0.0
```

然后再找到：

```
protected-mode yes
```

改为：

```
protected-mode no
```

保存退出（`Ctrl + O` → `Enter` → `Ctrl + X`）

------

## 🔐 四、设置 Redis 密码（强烈推荐）

启动查找:按下组合键：**`Ctrl` + `W`**
仍然在 `/etc/redis/redis.conf` 文件中找到：

```
# requirepass foobared
```

去掉注释并修改为：

```
requirepass 你的强密码
```

------

## 🔁 五、重启 Redis 服务

```
sudo systemctl restart redis-server
```

查看运行状态：

```
sudo systemctl status redis-server
```

输出中看到：

```
Active: active (running)
```

表示运行成功 ✅

------

## 🧪 六、测试 Redis

### 本地连接：

```
redis-cli
```

进入后测试：

```
127.0.0.1:6379> ping
PONG
```

### 远程连接：

如果设置了密码：

```
redis-cli -h 115.159.42.77 -p 6379 -a 123456

telnet 115.159.42.77 6379


```

------

## 📦 七、设置开机自启（可选）

```
sudo systemctl enable redis-server
```

------

## 🧰 八、常用命令

| 命令                             | 作用              |
| -------------------------------- | ----------------- |
| `redis-cli`                      | 启动 Redis 命令行 |
| `redis-cli -a 密码`              | 使用密码登录      |
| `systemctl start redis-server`   | 启动服务          |
| `systemctl stop redis-server`    | 停止服务          |
| `systemctl restart redis-server` | 重启服务          |
| `systemctl status redis-server`  | 查看状态          |

------

是