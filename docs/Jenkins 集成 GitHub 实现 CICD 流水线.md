# ⚙️ Jenkins 集成 GitHub 实现 CI/CD 流水线

> **通过 Jenkins 实现 GitHub Push 触发构建、测试、部署 mall 项目的基础 CI/CD 流程。**

## 🚩Jenkins  安装必要插件

打开 Jenkins 控制台 → "Manage Jenkins" → "Manage Plugins" 安装以下插件：

- Git
- GitHub
- Pipeline
- Publish Over SSH（如果涉及部署）
- allure

🚩二、环境准备

- 服务器安装 Git、Maven、JDK 

## 📥 1. 服务器安装 Git

```
sudo yum install git -y
which git  # 验证路径，一般是 /usr/bin/git
```

------

## 📥 2. 服务器安装 JDK（比如 Java 8）

如果你已经手动解压了 Java 8，比如放在 `/athena/jdk/jdk1.8.0_371`，就直接记住路径即可。

------

## 📥 3. 服务器安装 Maven

```
cd /athena/maven
sudo wget https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
tar -zxvf apache-maven-3.8.6-bin.tar.gz
# 安装路径就是 /athena/maven/apache-maven-3.8.6
```

------

## 📥 4. 服务器安装 allure

```
# 使用 wget 工具从 GitHub 下载 Allure 安装包
cd /athena/allure
wget https://github.com/allure-framework/allure2/releases/download/2.27.0/allure-2.27.0.tgz
#或者官方下载地址：https://github.com/allure-framework/allure2/releases/tag/2.27.0
```

## 🧰 Jenkins 全局工具配置（Global Tool Configuration）

> Jenkins 不安装这些工具本身，只是**引用系统里已有的 Git、JDK、Maven**，你必须先安装好它们，Jenkins 才能调用。

> 从 Jenkins 首页点击：**Manage Jenkins → Global Tool Configuration**
> 即可进入全局工具设置页面，下面我们开始依次配置 Git、JDK、Maven 和 Allure：

📦 1️⃣ Git 工具配置

- **名称**：`Default Git`
- **Path to Git executable**：`/usr/bin/git`

------

☕ 2️⃣ JDK 配置

- **名称**：`jdk8`
- **JAVA_HOME**：`/athena/jdk/jdk1.8.0_371`
- ✅ **取消勾选** `Install automatically`

------

🛠 3️⃣ Maven 配置

- **名称**：`maven-3.8.6`
- **MAVEN_HOME**：`/opt/apache-maven-3.8.6`
- ✅ **取消勾选** `Install automatically`

------

📊 4️⃣ Allure 配置（测试报告）

- **名称**：`allure`
- **ALLURE_HOME**：`/athena/allure2.7.0`
- ✅ **取消勾选** `Install automatically`

------

💾 最后操作

> 点击页面底部的 **Save** 按钮保存所有配置 ✅



## 🔐 GitHub 中 SSH and GPG keys 和 Personal Access Tokens (PAT)的区别

❓ **Add New SSH Key**

🔐SSH 密钥用于通过 SSH 连接模式，安全地推送、拉取代码以及访问 GitHub API。

❓ **Personal Access Tokens (Classic)**

🔐Personal Access Tokens（经典版）用于通过 HTTPS 连接模式，安全地推送、拉取代码以及访问 GitHub API。

## **📌GitHub 添加 Personal Access Token (PAT) **

1. **登录 GitHub**

   - 访问 [GitHub](https://github.com) 网站，使用你的账户登录。

2. **进入开发者设置**

   - 在页面右上角，点击你的头像，选择 **Settings**（设置）。
   - 在左侧菜单中，滚动并选择 **Developer settings**（开发者设置）。

3. **生成新令牌**

   - 在 **Developer settings** 页面，选择 **Personal access tokens**。
   - 点击右上角的 **Generate new token**（生成新令牌）按钮。

4. **选择令牌权限**

   - 在生成令牌页面，填写令牌的 **Note**（备注），以帮助你识别这个令牌的用途（例如，`Jenkins access`）。
   - 选择令牌的 **过期时间**（Expiration），可以选择 **30 days**、**60 days**、**No expiration**（永久）等选项，依据你的需求。
   - 勾选你需要的 **Scopes**（权限）。常见的权限包括：
     - **repo**：访问私有仓库
     - **workflow**：访问 GitHub Actions 工作流
     - **read:org**：读取组织信息（如果是组织仓库）
     - **admin:repo_hook**：管理仓库的 Webhook 设置
     - **delete:packages**：删除容器镜像和包

5. **生成令牌**

   - 完成选择后，点击 **Generate token**（生成令牌）按钮。
   - **注意**：生成的令牌只会显示一次，记得复制下来并保存在安全的地方。

6. **使用 PAT 进行身份验证**

   - 当你在 Git 中进行推送、拉取代码等操作时，Git 会要求你输入 GitHub 用户名和密码。

   - **用户名**：你的 GitHub 用户名（例如，`your-github-username`）
   - **密码**：粘贴你生成的 **Personal Access Token (PAT)**（例如，`ghp_abcdefgh12345678`）

   

##  📌GitHub **Add New SSH Key**

🛠️ 第一步：配置本地 Git 用户信息（非必须，但建议设置）

```
git config --global user.name "yjliu0808"
git config --global user.email "yjliu0808@163.com"
```

------

🗝️ 第二步：生成 SSH 密钥对（用于 GitHub 鉴权）

```
ssh-keygen -t rsa -b 4096 -C "yjliu0808@163.com"
```

- 连续按 **Enter**（3 次）即可
- 默认生成路径如下：
  - 私钥：`~/.ssh/id_rsa`
  - 公钥：`~/.ssh/id_rsa.pub`

------

📋 第三步：复制公钥并添加至 GitHub

```
cat ~/.ssh/id_rsa.pub
```

- 复制输出内容，到 GitHub 网站执行：
- 打开 GitHub → 右上角头像 → Settings
- 左侧栏点击「SSH and GPG keys」→ 点右上角绿色按钮 `New SSH key`
- 填写信息：
  - Title: `Jenkins SSH`
  - Key: 粘贴 `id_rsa.pub` 的内容
- 点击 **Add SSH key**

📡 第四步：测试 SSH 连通性

```
ssh -T git@github.com
```

✅如果你看到以下内容说明成功：

```
Hi yjliu0808! You've successfully authenticated, but GitHub does not provide shell access.
```

------



## 🔐添加凭证New credentials**类型**说明

🔍添加凭证**类型**说明：

| **凭证类型**                                          | **说明**                                                     |
| ----------------------------------------------------- | ------------------------------------------------------------ |
| **Username with Password（用户名与密码）**            | 传统的身份验证方式，用于通过 HTTPS 协议访问 GitHub 仓库。用户提供 GitHub 的用户名和密码进行身份验证。然而，GitHub 已经停止支持使用密码进行 Git 操作，推荐使用 Personal Access Token（PAT）代替密码。 |
| **GitHub App**                                        | GitHub 应用用于通过 OAuth 协议进行身份验证，并授权第三方应用访问 GitHub 资源。GitHub 应用通常用于集成和自动化，允许应用程序在 GitHub 上执行特定操作。 |
| **SSH Username with Private Key（SSH 用户名与私钥）** | 使用 SSH 密钥对进行身份验证的方式。用户提供 SSH 密钥的私钥部分（公钥存储在 GitHub 上），用于安全连接 GitHub。与传统的用户名和密码方式相比，SSH 密钥提供了更高的安全性。 |
| **Secret File（密钥文件）**                           | 这种凭证类型是指存储在文件中的秘密信息，通常用于在自动化工具或 CI/CD 环境中传递敏感数据（如 API 密钥、密码等）。这些文件内容在环境中不可见，通常加密存储。 |
| **Secret Text（密钥文本）**                           | 与密钥文件类似，这种凭证类型是指在配置中直接存储的敏感文本（如密钥或令牌）。这些文本信息用于自动化脚本或 CI/CD 流程中，并且通常被加密处理。 |
| **Certificate（证书）**                               | 证书用于加密通信和身份验证。它通常用于 SSL/TLS 协议中，以确保安全的网络连接。证书可以作为身份验证的一部分，用于确保通信双方的安全性和可信度。 |




------

## 📌 在 Jenkins 中配置 GitHub 凭据 -用户名与密码

- 🔐添加**Username with Password（用户名与密码）**类型凭证

  1. 打开 Jenkins → `Manage Jenkins` → `Manage Credentials`

  2. 点击左侧的 `Stores scoped to Jenkins` → `System` → `Global credentials (unrestricted)`
     系统管理->凭据->系统->全局凭据 (unrestricted)

  3. 点击右侧 `Add Credentials`

  4. 填写如下：

     | **字段名称**                 | **填写内容**                                                 |
     | ---------------------------- | ------------------------------------------------------------ |
     | **类型 (Type)**              | **Username with Password**（选择凭证类型为 "Username with Password"） |
     | **范围 (Scope)**             | **全局 (Global)**（选择此选项，以使凭证可在 Jenkins、节点、所有子项等处使用） |
     | **用户名 (Username)**        | 输入 GitHub 用户名，例如 `your-github-username`              |
     | **Treat username as secret** | **勾选**（如果该选项是可用的，表示将用户名视为密文保护）     |
     | **密码 (Password)**          | 输入 **Personal Access Token (PAT)**，例如 `ghp_exampleToken` |
     | **ID (凭证 ID)**             | **自定义**（设置一个唯一的凭证 ID，方便未来引用此凭证，例如 `GitHub-Username-Password`） |
     | **描述 (Description)**       | **填写描述**，例如 `GitHub Username and Personal Access Token`（描述此凭证用途） |

## 📌 在 Jenkins 中配置 GitHub 凭据 - SSH 用户名与私钥

🔐添加**SSH Username with Private Key（SSH 用户名与私钥）**类型凭证

1. 打开 Jenkins → `Manage Jenkins` → `Manage Credentials`

2. 点击左侧的 `Stores scoped to Jenkins` → `System` → `Global credentials (unrestricted)`
   系统管理->凭据->系统->全局凭据 (unrestricted)

3. 点击右侧 `Add Credentials`

   | **字段名称**                  | **填写内容**                                                 |
   | ----------------------------- | ------------------------------------------------------------ |
   | **类型 (Type)**               | **SSH Username with Private Key**（选择凭证类型为 "SSH Username with Private Key"） |
   | **范围 (Scope)**              | **全局 (Global)**（选择此选项，使凭证适用于 Jenkins、节点、所有子项等） |
   | **ID (凭证 ID)**              | **自定义**（设置一个唯一的凭证 ID，方便未来引用此凭证，例如 `GitHub-SSH-Key`） |
   | **描述 (Description)**        | **填写描述**，例如 `GitHub SSH Key for Jenkins`（描述此凭证用途） |
   | **用户名 (Username)**         | `git`（固定值）（GitHub 默认 SSH 用户名为 `git`）            |
   | **Treat username as secret**  | **勾选**（表示将用户名视为密文处理，增强安全性）             |
   | **Private Key**               | **Enter directly**（选择手动输入私钥）                       |
   | **Key (私钥)**                | `cat ~/.ssh/id_rsa` 的输出内容，特别注意这里用的私钥         |
   | **Passphrase (密钥密码短语)** | **如果私钥有密码保护，填写此字段**，否则可以留空（如果你在生成 SSH 密钥时设置了密码短语，请输入该密码） |

   

------



## 🧱Jenkins + GitHub CICD 部署步骤

### 🔢步骤一：github新建仓库 ：**[SimplePerfMall](https://github.com/yjliu0808/SimplePerfMall)**

```
新建仓库的SSH地址：git@github.com:yjliu0808/SimplePerfMall.git
```

### 🔢步骤二：github新建的仓库内设置**网络钩子**Webhook

- 新增“**网络钩子**Webhook：

  - github仓库 ：**[SimplePerfMall](https://github.com/yjliu0808/SimplePerfMall)** -> [Settings](https://github.com/yjliu0808/SimplePerfMall/settings) ->[Webhooks /](https://github.com/yjliu0808/SimplePerfMall/settings/hooks) Add webhook

  - 可填写如下信息：GitHub Webhook 配置表

    ****

    | **字段名称**                                             | **推荐填写内容/勾选项**                      |
    | -------------------------------------------------------- | -------------------------------------------- |
    | **Payload URL**                                          | `http://129.28.122.208:8081/github-webhook/` |
    | **Content type**                                         | `application/x-www-form-urlencoded`          |
    | **Secret**                                               | 留空（不填写）                               |
    | **SSL verification**                                     | 勾选 **Enable SSL verification**             |
    | **Which events would you like to trigger this webhook?** | 勾选 **Just the `push` event**               |
    | **Active**                                               | 勾选 **Active**（启用 Webhook）              |

**📌配置完成验证方式：**

**Webhooks模块内：点击链接进去详情：有[Recent Deliveries](https://github.com/yjliu0808/api_auto_mall_v1.5test/settings/hooks/540042535?tab=deliveries)可以查看是否有push记录**

### 🔢步骤三：Jenkins新建任务

1. 进入 Jenkins 管理界面

   - 打开 Jenkins 控制台，在浏览器地址栏中输入 Jenkins 服务器的 URL。
   - 登录 Jenkins 系统，进入首页。

2. 创建新任务

   - 在 Jenkins 主界面，点击左侧菜单中的 **New Item**（新建项目）按钮。
   - 在弹出的 **Enter an item name**（输入项目名称）框中，输入任务名称，如：`SimplePerfMall`。
   - 选择 **流水线（Pipeline）** 类型（这是 Jenkins 最常用的任务类型之一）。
   - 点击 **OK**。

3. 配置任务的基本信息

   | Configure                          | **字段名称**                          | **推荐填写内容/操作**                                        |
   | ---------------------------------- | ------------------------------------- | ------------------------------------------------------------ |
   | **⚙️General（基本配置）**           | **描述 (Description)**                | 在 **General** 标签页下，填写任务的描述信息，例如：`测试简单的mall项目实现CICD` |
   |                                    | **GitHub 项目 (GitHub Project)**      | 勾选 **GitHub 项目** 选项，并在 **Project URL** 字段中输入你的 GitHub 项目地址，例如：`https://github.com/yjliu0808/SimplePerfMall` |
   | **Triggers（触发器）⏰**            | **触发器 (Triggers)**                 | 在 **Triggers** 标签页下，勾选 **GitHub hook trigger for GITScm polling**，表示 Jenkins 会通过 GitHub Webhook 触发任务执行 |
   | **步骤 5：配置流水线（Pipeline）** | **流水线类型 (Pipeline)**             | 选择 **Pipeline script from SCM**（从 SCM 获取流水线脚本）   |
   |                                    | **SCM (版本控制工具)**                | 在 **SCM** 字段中，选择 **Git**                              |
   |                                    | **Repository URL (仓库 URL)**         | 在 **Repository URL** 字段中，输入你的 GitHub 仓库 URL，例如：`git@github.com:yjliu0808/SimplePerfMall.git` |
   |                                    | **Credentials (凭证)**                | 在 **Credentials** 字段中，选择之前配置的 **GitHub SSH Key私钥凭证** |
   |                                    | **Branches to build (构建分支)**      | 在 **Branches to build** 字段中，指定要构建的分支，例如：`*/main` |
   |                                    | **脚本路径 (Script Path)**            | 在 **脚本路径 (Script Path)** 字段中，填写你的 **Jenkinsfile** 文件路径，通常是 `Jenkinsfile` |
   |                                    | **轻量级检出 (Lightweight checkout)** | 勾选 **轻量级检出**（Lightweight checkout）选项，以提高构建效率 |

**🎯 Repository URL (仓库 URL)**

- 若填写 **HTTP** 地址的仓库 URL，那么 **Credentials (凭证)** 需要使用 **用户名与密码** 类型的凭证（即 GitHub 用户名和 **Personal Access Token (PAT)**）。
- 若填写 **SSH** 地址的仓库 URL，那么 **Credentials (凭证)** 需要使用 **SSH Username with Private Key** 类型的凭证，并选择合适的 **SSH 密钥** 进行身份验证。

**✅填写以上信息save即可**

### 🔢步骤四：本地克隆 Maven 项目上传到 GitHub

1. 克隆你的 GitHub 仓库到本地：

   ```
   git clone git@github.com:yjliu0808/SimplePerfMall.git
   ```

2. 根目录下创建 Jenkinsfile

   在本地仓库的根目录下新建一个名为 `Jenkinsfile` 的文件，文件内容如下：

   ```
   pipeline {
       agent any
   
       triggers {
           githubPush()   // 👈 加上这一段
       }
   
       stages {
           stage('Triggered') {
               steps {
                   echo '🎉 Jenkins CI/CD 已被 GitHub Push 成功触发!'
               }
           }
       }
   }
   
   ```

3. 提交并推送更改

   执行以下命令，将新的 Jenkinsfile 文件添加到 Git 仓库中并推送到 GitHub：

   ```
   git add .
   git commit -m "检查CICD流程是否正常"
   git push
   ```

4. **📌配置完成验证方式：**

   **Webhooks模块内：点击链接进去详情：有[Recent Deliveries](https://github.com/yjliu0808/api_auto_mall_v1.5test/settings/hooks/540042535?tab=deliveries)可以查看是否有push记录**

5. 若没有自动构建，手动触发 Jenkins 构建

   如果 Jenkins 没有自动构建，请手动触发构建。首次触发构建时，可以通过 Jenkins Web 控制台执行手动构建。



------

✅ 整体流程总结图

```
本地提交代码
      ↓ push
GitHub 触发 Webhook
      ↓
Jenkins 接收到通知
      ↓
自动拉取最新代码（Git）
      ↓
执行 Jenkinsfile 
```

### 🎯Jenkins GitHub Push 自动触发构建问题排查总结

✅ 问题背景

通过 GitHub Push 自动触发 Jenkins 构建失败，最终通过排查与配置修复完成。

------

🧩 问题总结

1. Git 命令无响应

- **现象**：服务器执行 `git status` 无反应。
- **操作**：重新安装了 Git，确保可正常执行 Git 命令。
- **原因分析**：系统中的 Git 工具可能损坏或未完整安装，导致 Jenkins 在拉取代码时挂起。

2. 仓库地址使用 SSH 协议

- **配置项**：Repository URL 设置为：

  ```
  git@github.com:yjliu0808/TESTCICD.git
  ```

- **注意事项**：

  - 必须确保 Jenkins 服务器上的 `jenkins` 用户拥有访问该地址的权限。
  - 需信任 GitHub 的 SSH Host Key。

3. Jenkins SSH 凭据配置错误

- **尝试方式**：
  - 用户名 + 密码：❌（403 错误）
  - 用户名 + 私钥文件路径：❌（Jenkins 无法识别文件路径）
  - SSH Username with private key + 粘贴服务器私钥：✅
- **最终成功配置**：
  - 类型：`SSH Username with private key`
  - ID：`github-ssh`
  - Username：`git`
  - Private Key：复制粘贴 Jenkins 用户目录下 `.ssh/id_rsa` 私钥内容

🔐 如何生成并使用 SSH 密钥：

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

4. 首次构建需手动触发

- **现象**：Push 后无响应，但 Webhook 收到请求
- **操作**：首次点击 Jenkins 页面上的 `Build Now` 执行一次手动构建
- **原因分析**：首次构建后 Jenkins 会初始化流水线上下文，此后才可被 Push 自动触发

------

📄 关键配置项确认清单

-  Git 已正确安装并在系统中可用
-  Jenkins 项目中使用 SSH 地址进行仓库连接
-  Jenkins Credentials 中添加了 SSH 凭据并关联
-  Jenkinsfile 中包含 `triggers { githubPush() }`
-  项目勾选 `GitHub hook trigger for GITScm polling`
-  GitHub Webhook 指向 Jenkins 地址（如：http://<your_ip>:8080/github-webhook/）
-  Jenkins 用户可通过 SSH 成功连接 GitHub：`ssh -T git@github.com`
-  **首次构建需在 Jenkins 中手动点击 Build Now 初始化**

------

🔁 推荐操作流程

1. 确保服务器 Git 安装正常：`git --version`
2. 在服务器生成 SSH 密钥对，并配置到 GitHub
3. 将 SSH 私钥添加到 Jenkins Credentials
4. Jenkins 项目配置使用该 SSH 凭据并填写 SSH 仓库地址
5. Jenkinsfile 中加上 `githubPush()` 触发器
6. 项目勾选 `GitHub hook trigger for GITScm polling`
7. GitHub 仓库添加 webhook 指向 Jenkins 地址
8. **首次进入 Jenkins 页面点击一次 `Build Now` 执行构建**

------

✅ 最终结果

- GitHub Push 可成功触发 Jenkins 构建
- Jenkins 拉取仓库成功并执行流水线
- 自动化流程配置完成，稳定运行

------


