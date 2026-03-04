---
author: Athena
up: A_目录/index
tags:
  - 学习笔记
created: 2025-11-09
modified: 2025-11-09
---
# 👉 [返回上级目录](obsidian://open?vault=Notebook&file=B_%E7%9F%A5%E8%AF%86%2Findex)  
# 🧭 软件测试学习笔记

> 🎓 本知识库系统整理了软件测试从基础理论到项目实战的完整体系，涵盖功能、性能、安全、自动化与 CI/CD 部署等核心方向，支持 Dataview 自动生成导航。

---
## 📚 章节导航

```dataviewjs

```
```dataviewjs
// ✅ 当前文件夹路径（例如 "B_知识"）
const currentFolder = dv.current().file.folder;

// ✅ 收集所有下一级文件夹
const subfolders = new Set();
for (let page of dv.pages(`"${currentFolder}"`)) {
  const relative = page.file.folder.replace(currentFolder + "/", "");
  const firstSub = relative.split("/")[0];
  if (firstSub && !firstSub.includes("/")) subfolders.add(firstSub);
}

// ✅ 转成数组并按“数字顺序 + 拼音”排序
let sorted = [...subfolders].sort((a, b) => {
  const numA = parseInt(a.match(/^\d+/)?.[0] || 999);
  const numB = parseInt(b.match(/^\d+/)?.[0] || 999);
  if (numA !== numB) return numA - numB;
  return a.localeCompare(b, 'zh-Hans-CN');
});

// ✅ 让 "B_知识" 永远排最前（但不显示它）
if (sorted.includes("B_知识")) {
  sorted = sorted.filter(x => x !== "B_知识");
}

// ✅ 判断当前文件层级，自动生成正确路径
for (let f of sorted) {
  let linkPath = "";
  if (currentFolder === "" || currentFolder === "A_目录") {
    // 顶层或主目录（直接指向 B_知识/...）
    linkPath = `B_知识/${f}/index`;
  } else if (currentFolder === "B_知识") {
    // B_知识层（避免重复 B_知识/B_知识）
    linkPath = `B_知识/${f}/index`;
  } else {
    // 其他情况（正常拼接）
    linkPath = `${currentFolder}/${f}/index`;
  }
  dv.paragraph(`- [[${linkPath}|${f}]]`);
}

```

---

## 🔍 近期更新

```dataview
table file.name as "文件名", file.path as "文件夹", file.mtime as "修改时间"
from "/"
sort file.mtime desc
limit 5
```

---

🗓️ 最后更新：`=dateformat(this.file.mtime, "yyyy-MM-dd HH:mm")`

