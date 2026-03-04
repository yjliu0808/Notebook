## 🧩 一、更新系统软件包

在安装前，先更新系统索引：

```
sudo apt update
sudo apt upgrade -y
```

------

## 🌐 二、安装 Nginx

直接使用 apt 安装：

```
sudo apt install nginx -y
```

安装完成后，Nginx 会自动启动。

------

## ⚙️ 三、检查 Nginx 服务状态

```
sudo systemctl status nginx
```

如果输出中出现：

```
Active: active (running)
```

说明 Nginx 已经运行成功 ✅

退出状态查看界面：按 **`Q`**

------

## 🚀 四、验证安装

### 1. 本地访问

在浏览器输入：

```
http://localho
```

或：

```
http://127.0.0.1
```

如果你是在远程服务器上：

```
http://115.159.42.77
```

会看到 **“Welcome to nginx!”** 页面，说明安装成功 🎉

------

## 🔁 五、常用操作命令

| 操作                       | 命令                           |
| -------------------------- | ------------------------------ |
| 启动 Nginx                 | `sudo systemctl start nginx`   |
| 停止 Nginx                 | `sudo systemctl stop nginx`    |
| 重启 Nginx                 | `sudo systemctl restart nginx` |
| 重新加载配置（不重启进程） | `sudo systemctl reload nginx`  |
| 查看状态                   | `sudo systemctl status nginx`  |
| 设置开机自启               | `sudo systemctl enable nginx`  |
| 取消开机自启               | `sudo systemctl disable nginx` |

------

## 🧱 六、配置文件路径结构

默认安装后，配置路径如下：

| 文件/目录                         | 作用                      |
| ----------------------------- | ----------------------- |
| `/etc/nginx/nginx.conf`       | 主配置文件                   |
| `/etc/nginx/sites-available/` | 虚拟主机配置目录                |
| `/etc/nginx/sites-enabled/`   | 启用的虚拟主机链接目录             |
| `/var/www/html/`              | 默认网站根目录（index.html 在这里） |
| `/var/log/nginx/access.log`   | 访问日志                    |
| `/var/log/nginx/error.log`    | 错误日志                    |
| /var/www/html/dist            | 将打包好的dist文件上传即可         |

------

## 🌍 七、配置防火墙（如使用 UFW）

Ubuntu 通常带有 UFW 防火墙，可以允许 HTTP/HTTPS：

```
sudo ufw allow 'Nginx Full'
sudo ufw status
```

输出中应看到：

```
Nginx Full                   ALLOW
```

------

## 🧪 八、测试配置文件语法

修改 Nginx 配置文件后，先测试语法再重启：

```
sudo nginx -t
```

若输出：

```
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

即可安全重启：

```
sudo systemctl reload nginx
```

------

