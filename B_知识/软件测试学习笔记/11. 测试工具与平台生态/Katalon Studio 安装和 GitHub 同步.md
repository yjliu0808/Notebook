# Katalon Studio 安装和 GitHub 同步

## 安装 Katalon Studio

### 1. 下载

- 官网：https://katalon.com/download
- GitHub：https://github.com/katalon-studio/katalon-studio/releases

选择对应系统的版本下载。

### 2. 安装步骤

1. 运行 `KatalonSetup.exe`
2. 等待下载组件完成
3. 安装完成后会自动启动

### 3. 新建项目

启动后选择：
- **Start with**：选择 `Blank Project`（空白项目）或 `Sample Project`（示例项目）
- **项目类型**：
  - Web UI Testing（网站测试）
  - API Testing（接口测试）
  - Mobile Testing（手机 App 测试）
  - Desktop Testing（桌面应用测试）
  - Combined（综合测试）

## 卸载 Katalon

### 1. 通过系统设置卸载

- **设置** → **应用** → **已安装的应用** → 找到 Katalon → **卸载**

或

- **控制面板** → **程序和功能** → 找到 Katalon → **卸载**

### 2. 清理残留文件

```powershell
# 删除开始菜单快捷方式
Remove-Item -Recurse -Force "C:\Users\Athena\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Katalon"

# 删除本地配置
Remove-Item -Recurse -Force "C:\Users\Athena\AppData\Local\katalon.setup"
```

## 同步到 GitHub

本地已有 Katalon 项目，需要推送到 GitHub。

### 1. 初始化 Git 并添加远程仓库

```powershell
# 进入项目目录
cd "D:\github\katalon-hk-move2-test-automation-lib"

# 初始化 Git
git init

# 添加安全目录例外
git config --global --add safe.directory "D:/github/katalon-hk-move2-test-automation-lib"

# 添加远程仓库
git remote add origin git@github.com:yjliu0808/katalon-hk-move2-test-automation-lib.git
```

### 2. 添加文件并提交

```powershell
# 添加所有文件
git add .

# 提交
git commit -m "first commit from local"
```

### 3. 推送到 GitHub

```powershell
# 设置主分支名
git branch -M main

# 推送
git push -u origin main
```

### 4. 处理冲突（如果远程有内容）

如果远程仓库有内容，推送失败，需要先拉取合并：

```powershell
# 拉取并合并
git pull origin main --allow-unrelated-histories

# 解决冲突后，添加并提交
git add .
git commit -m "merge and resolve conflict"

# 再次推送
git push origin main
```

## 常见问题

### Q: 安装后打不开

A: 检查 JAVA_HOME 环境变量是否配置正确。

### Q: 推送被拒绝

A: 远程有内容导致冲突，需要先 `git pull` 合并。

### Q: Git 权限问题

A: 检查 GitHub SSH key 是否配置正确：
```powershell
ssh -T git@github.com
```