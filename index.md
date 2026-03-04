---
author: Athena
up: Notebook/index
tags:
  - 根目录
created: 2025-11-09
modified: 2025-11-09
---

# 📚 Notebook 根目录

> 欢迎来到我的软件测试学习笔记！以下是 Obsidian 存储库根目录的目录结构，包含了不同的学习区域和整理好的笔记。通过此页面，您可以快速跳转到各个部分进行学习和查看。

---

## 🚀 快速入口

👉 [进入A_目录](obsidian://open?vault=Notebook&file=A_%E7%9B%AE%E5%BD%95%2Findex)   
👉 [进入B_知识](obsidian://open?vault=Notebook&file=B_%E7%9F%A5%E8%AF%86%2Findex)  

---

## 🔍 近期更新

```dataview
table file.name as "文件名", file.path as "文件夹", file.mtime as "修改时间"
from "/"
sort file.mtime desc
limit 5
```



---

## 📈 使用提示

- 🔁 自动目录由 **Dataview** 驱动，新增章节时会自动更新  
- ✍️ 每个章节都有一个独立的 `index.md` 作为目录页  
- 🧩 推荐启用插件：
  - Dataview → 自动生成导航  
  - Templater → 快速创建章节模板  
  - Breadcrumbs → 层级路径导航  
  - Hover Editor → 悬浮预览笔记  

✍️添加笔记属性：
```
---
author: Athena
up: A_目录/index
tags:
  - 软件测试
created: 2025-11-09
modified: 2025-11-09
---
```