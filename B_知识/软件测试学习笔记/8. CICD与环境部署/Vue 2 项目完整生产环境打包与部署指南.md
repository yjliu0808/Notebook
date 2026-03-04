# 🧭 一、项目结构说明

典型 Vue 2 CLI 项目结构如下：

```
project/
├── build/
│   └── webpack.prod.conf.js
├── config/
│   ├── dev.env.js
│   ├── prod.env.js
│   └── index.js
├── src/
│   ├── main.js
│   ├── App.vue
│   ├── api/
│   └── components/
├── package.json
└── dist/          # 打包后生成的文件夹
```

------

# ⚙️ 二、配置多环境 API

## 1️⃣ 编辑环境变量文件

### `config/dev.env.js`（开发环境）

```
'use strict'
const merge = require('webpack-merge')
const prodEnv = require('./prod.env')

module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  BASE_API: '"http://localhost:8089"'  // 本地或测试环境接口
})
```

### `config/prod.env.js`（生产环境）

```
'use strict'
module.exports = {
  NODE_ENV: '"production"',
  BASE_API: '"http://115.159.42.77:8089"' // 正式服务器接口
}
```

------

## 2️⃣ 在代码中使用环境变量

在你的 `src/utils/request.js` 或 `axios` 初始化处引用：

```
import axios from 'axios'

const service = axios.create({
  baseURL: process.env.BASE_API, // 自动切换
  timeout: 10000
})

export default service
```

> ⚡ 在构建时，webpack 会自动将 `process.env.BASE_API` 替换为相应值。

------

# 🏗️ 三、生产环境打包命令

## 1️⃣ 安装依赖

```
npm install
```

```
切换node版本
- `nvm install 14.21.3` (如果还没装)
    
- `nvm use 14.21.3`
    
- `node -v` (确认是 v14)
    
- **回到你的项目目录**，执行 `npm install`。
```
## 2️⃣ 打包

```
npm run build
```

执行后会输出：

```
> vue-cli-service build

 DONE  Build complete. The dist directory is ready to be deployed.
```

生成的文件位于：

```
dist/
```

------

# 🧱 四、Nginx 生产部署配置

假设你已经在 Ubuntu 24.04 上安装了 Nginx。
 路径一般是 `/etc/nginx/sites-available/`。

## 1️⃣ 创建新配置文件

```
sudo nano /etc/nginx/sites-available/vue.conf
```

### 内容如下：

```
server {
    listen 80;
    server_name 115.159.42.77;

    # Vue 项目打包文件路径
    root /var/www/html/dist;
    index index.html;

    # 前端 history 模式兼容
    location / {
        try_files $uri $uri/ /index.html;
    }

    # 反向代理接口到后端 API 服务
    location /api/ {
        proxy_pass http://115.159.42.77:8089/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # 可选：静态文件缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 7d;
        access_log off;
    }
}
```

## 2️⃣ 启用配置并重启 Nginx

```
sudo ln -s /etc/nginx/sites-available/vue.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

------

# 🌐 五、部署流程总结

| 步骤       | 命令                                             | 说明             |
| ---------- | ------------------------------------------------ | ---------------- |
| 更新项目   | `git pull`                                       | 拉取最新代码     |
| 安装依赖   | `npm install`                                    | 安装依赖包       |
| 打包       | `npm run build`                                  | 打包生成静态文件 |
| 上传       | `scp -r dist/ user@115.159.42.77:/var/www/html/` | 上传到服务器     |
| 重启 Nginx | `sudo systemctl reload nginx`                    | 应用新版本       |

------

# 🧪 六、验证

访问：

```
http://115.159.42.77
```

如果看到你的页面 ✅，并且浏览器 Network 面板中接口请求发向：

```
http://115.159.42.77:8089/api/xxx
```

说明打包和反代配置生效。

------

# 🔒 七、可选：开启 HTTPS（推荐生产环境）

使用 **Certbot** 快速配置 Let’s Encrypt 免费证书：

```
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

自动生成证书并修改 Nginx 配置，支持 HTTPS。

------

# ✅ 八、环境切换总结

| 环境   | 命令                       | API 地址                    | 说明   |
| ---- | ------------------------ | ------------------------- | ---- |
| 开发环境 | `npm run dev`            | http://localhost:8089     | 热更新  |
| 测试环境 | `npm run build`（改测试 API） | http://test.server:8089   | 打包   |
| 生产环境 | `npm run build`          | http://115.159.42.77:8089 | 正式部署 |

------

