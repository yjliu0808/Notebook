# 卸载并重新安装 TortoiseGit

## 1. 卸载 TortoiseGit

如果你之前已经安装过 TortoiseGit 并希望重新安装，可以按照以下步骤卸载现有版本：

### 1.1 打开“控制面板”

1. 按下 **Win + R**，打开“运行”对话框。
2. 输入 **`control`** 并按 **Enter**，进入控制面板。

### 1.2 卸载 TortoiseGit

1. 在控制面板中，点击 **“程序”** 或 **“程序和功能”**。
2. 在列表中找到 **TortoiseGit**。
3. 右键点击 **TortoiseGit**，选择 **卸载**。
4. 按照提示完成卸载过程。

### 1.3 清理残留文件（可选）

卸载 TortoiseGit 后，有时会残留一些配置文件。你可以手动删除以下文件夹（如果它们存在）：

- **`C:\Program Files\TortoiseGit`**：如果没有被自动删除，可以手动删除这个文件夹。
- **`C:\Users\<你的用户名>\AppData\Local\TortoiseGit`** 和 **`C:\Users\<你的用户名>\AppData\Roaming\TortoiseGit`**：这些是用户配置文件夹，可以手动删除。

## 2. 重新安装 TortoiseGit

### 2.1 下载 TortoiseGit 安装包

1. 访问 [TortoiseGit 官方网站](https://tortoisegit.org/)。
2. 根据你的操作系统选择适合版本（如 32 位或 64 位）。
3. 下载最新版本的 TortoiseGit 安装包。

### 2.2 安装 TortoiseGit

1. 双击下载的安装包启动安装程序。
2. 在安装过程中，按提示进行配置。
   - 选择语言（一般选择 **英语**）。
   - 选择安装目录（默认路径一般是 **C:\Program Files\TortoiseGit**）。
   - 安装时会询问是否安装 Git，通常你可以选择 **是**，如果你已经安装 Git，则可以选择跳过。

### 2.3 完成安装

- 安装完成后，点击 **Finish**，TortoiseGit 会自动创建桌面快捷方式和文件夹选项。
- 安装完成后，建议重新启动计算机以确保所有组件生效。

## 3. 配置 TortoiseGit

安装完成后，配置 TortoiseGit 以便正常使用。

### 3.1 配置 Git 用户信息

1. 右击桌面或文件夹，选择 **TortoiseGit** → **Settings**。
2. 在 **Settings** 窗口中，选择 **Git** → **Config**。
3. 填写你的 **用户名** 和 **电子邮件地址**：
   - **User Name**：你的用户名（例如：`Your Name`）
   - **User Email**：你的电子邮件地址（例如：`your_email@example.com`）

### 3.2 配置 TortoiseGit 界面语言（可选）

如果你希望更改 TortoiseGit 的界面语言，可以在 **Settings** 窗口中选择 **Language**，并选择你喜欢的语言。

### 3.3 配置 TortoiseGit 的默认编辑器（可选）

如果你希望使用某个文本编辑器（例如 **Notepad++** 或 **Visual Studio Code**）来编辑提交信息，可以在 **Settings** 中设置默认编辑器：
1. 打开 **Settings**。
2. 选择 **General** → **Diff Viewer**。
3. 在 **External Diff Viewer** 中，选择你喜欢的编辑器路径。

## 4. 使用 TortoiseGit 进行 Git 操作

安装并配置完 TortoiseGit 后，你可以通过图形界面执行 Git 操作，而不需要使用命令行。

### 4.1 初始化 Git 仓库（如果尚未初始化）

1. 在你想要初始化 Git 仓库的文件夹中，右键点击文件夹，选择 **Git Create repository here...**。
2. 这会在当前文件夹中创建一个新的 `.git` 文件夹，标志着该文件夹是一个 Git 仓库。

### 4.2 添加文件并提交更改

1. **修改文件**：例如，修改 `demo.txt` 文件。
2. **添加文件到 Git 暂存区**：右键点击文件夹，选择 **TortoiseGit** → **Add...**，然后选择要添加到 Git 仓库的文件。
3. **提交更改**：右键点击文件夹，选择 **TortoiseGit** → **Commit...**。在弹出的提交窗口中，勾选你想提交的文件并填写提交信息，点击 **Commit** 按钮进行提交。

### 4.3 查看提交历史

1. 右键点击仓库文件夹，选择 **TortoiseGit** → **Show Log**。
2. 在弹出的 **Log** 窗口中，你可以查看所有的提交历史。

### 4.4 查看文件差异

1. 右键点击修改过的文件，选择 **TortoiseGit** → **Diff**。
2. 这将显示文件与上一次提交之间的差异。

### 4.5 拉取和推送远程仓库

- **拉取远程仓库的更改**：
  - 右键点击文件夹，选择 **TortoiseGit** → **Pull...**。
  
- **推送更改到远程仓库**：
  - 右键点击文件夹，选择 **TortoiseGit** → **Push...**。

## 5. 常见问题和解决方法

### 5.1 TortoiseGit 提示“权限问题”

如果你在使用 TortoiseGit 时遇到权限问题，确保你使用管理员权限运行 TortoiseGit。右键点击 TortoiseGit 快捷方式，选择 **以管理员身份运行**。

### 5.2 远程仓库设置问题

如果你无法连接到远程仓库，确保你的远程仓库 URL 配置正确，并且你已经正确配置了 SSH 密钥（如果使用 SSH 连接）。

## 小结

通过 TortoiseGit，你可以轻松地通过图形界面进行 Git 操作，而不需要使用命令行。它提供了丰富的功能，包括提交、查看差异、查看提交历史、拉取和推送远程仓库的更改等。

如果你重新安装并配置了 TortoiseGit，你就可以继续在你的项目中使用它来管理 Git 仓库，享受图形化操作带来的便利。