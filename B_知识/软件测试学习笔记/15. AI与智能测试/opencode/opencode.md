# OpenCode 安装指南

## Windows 快速安装

1. 安装 Node.js 18+。
2. 打开 CMD 或 PowerShell。
3. 执行：

```bash
npm install -g opencode-ai
```

4. 验证：

```bash
opencode --version
```

---

## Windows NVM 安装方案（可选）

如果需要使用 NVM 管理 Node.js 版本，可以使用以下方法：

### 1. 安装 NVM for Windows

```powershell
# 下载 nvm-noinstall.zip
curl.exe -L -o nvm-noinstall.zip https://ghfast.top/https://github.com/coreybutler/nvm-windows/releases/download/1.1.12/nvm-noinstall.zip

# 解压
Expand-Archive -Path .\nvm-noinstall.zip -DestinationPath . -Force

# 删除压缩包
Remove-Item .\nvm-noinstall.zip
```

### 2. 配置 settings.txt

```powershell
@'
root: D:\install\static install\nvm
path: C:\Program Files\nodejs
arch: 64
proxy: none
node_mirror: https://npmmirror.com/mirrors/node/
npm_mirror: https://npmmirror.com/mirrors/npm/
'@ | Out-File -FilePath .\settings.txt -Encoding ascii
```

### 3. 设置环境变量

```powershell
# 设置 NVM_HOME
[Environment]::SetEnvironmentVariable("NVM_HOME", "D:\install\static install\nvm", "Machine")

# 设置 NVM_SYMLINK
[Environment]::SetEnvironmentVariable("NVM_SYMLINK", "C:\Program Files\nodejs", "Machine")

# 添加到 PATH
$oldPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($oldPath -notlike "*%NVM_HOME%*") {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;%NVM_HOME%;%NVM_SYMLINK%", "Machine")
}
```

### 4. 配置 NPM

```powershell
# 设置 npm 全局包路径
npm config set prefix "D:\install\static install\nodejs\node_global"

# 设置 npm 缓存路径
npm config set cache "D:\install\static install\nodejs\node_cache"

# 将全局路径添加到 PATH
$globalPath = "D:\install\static install\nodejs\node_global"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($oldPath -notlike "*$globalPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$globalPath", "Machine")
}
```

> ⚠️ 注意：修改环境变量后需要 **重启终端** 才能生效。

## 安装 OpenCode

```powershell
# 安装 opencode
npm install -g opencode-ai

# 验证安装
opencode --version
```

如果安装后仍提示找不到命令，尝试：
1. 重启终端
2. 检查 PATH 环境变量是否包含 npm 全局路径
3. 运行 `npm config get prefix` 确认全局路径配置正确

## 常见问题

### Q: 安装后 opencode 命令找不到

A: 确保已重启终端，并验证以下内容：
- `echo $env:PATH` 检查是否包含 `D:\install\static install\nodejs\node_global`
- `npm config get prefix` 确认输出为 `D:\install\static install\nodejs\node_global`
- 检查 `D:\install\static install\nodejs\node_global` 目录是否包含 opencode 可执行文件