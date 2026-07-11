# 二、Windows 安装（你现在环境重点）

## 1️⃣ 下载

👉 官网：  
[https://ollama.com/download](https://ollama.com/download)

选择：

> **Download for Windows**

---

## 2️⃣ 安装步骤

双击 `.exe` → 一路 Next：

- 默认路径即可
    
- 自动配置环境变量（很重要）
    

---

## 3️⃣ 验证安装

打开 **CMD / PowerShell**：

ollama --version

如果输出版本号，例如：

ollama version 0.x.x

✅ 成功

---

# 三、核心：下载模型

## 1️⃣ 拉取模型（最关键一步）

cmd窗口运行：

ollama pull mistral

📌 说明：

- 大约 4GB
    
- 第一次会慢（正常）
    
---

# 四、运行模型（测试）

## 方式1：直接聊天

ollama run mistral

然后输入：

你好

如果返回内容 👉 成功