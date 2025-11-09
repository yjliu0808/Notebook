👉 [返回上级目录](obsidian://open?vault=Notebook&file=B_%E7%9F%A5%E8%AF%86%2Findex)  
# 🧭 软件测试学习笔记

> 🎓 本知识库系统整理了软件测试从基础理论到项目实战的完整体系，涵盖功能、性能、安全、自动化与 CI/CD 部署等核心方向，支持 Dataview 自动生成导航。

---
## 📚 章节导航（手动写的可读版）
 [1. 基础理论]()
 [2. 编程与脚本语言]()
 [3. Linux与系统操作]()
 [4. 数据库与数据验证]()
 [5. 自动化测试]()
 [6. 性能测试]()
 [7. 安全测试]()
 [8. CICD与环境部署]()
 [9. 项目实践]()
 [10. 测试管理与质量保障]()
 [11. 测试工具与平台生态]()
 [12. 学习与职业发展]()
 [13. 附录与资源]()
 [14. 测试开发与平台建设]()
 [15. AI与智能测试]()

---

## 🚀 快速入口

👉 [进入A_目录](obsidian://open?vault=Notebook&file=A_%E7%9B%AE%E5%BD%95%2Findex)   
👉 [进入B_知识](obsidian://open?vault=Notebook&file=B_%E7%9F%A5%E8%AF%86%2Findex)  
👉 [进入C_临时](obsidian://open?vault=Notebook&file=C_%E4%B8%B4%E6%97%B6%2Findex)  
👉 [回到根目录](obsidian://open?vault=Notebook&file=index)

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

---

🗓️ 最后更新：`=dateformat(this.file.mtime, "yyyy-MM-dd HH:mm")`