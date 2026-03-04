# 📘 2. 编程与脚本语言

> 本章节为《软件测试学习笔记》的一部分，详细介绍 2. 编程与脚本语言 的相关知识与实践内容。

## 📚 章节导航

```dataviewjs
// 获取当前文件所在文件夹（例如 "B_知识"）
const currentFolder = dv.current().file.folder;

// 查询当前文件夹下的所有文件（排除当前文件）
const pages = dv.pages(`"${currentFolder}"`)
  .where(p => p.file.name !== dv.current().file.name) // 排除当前文件
  .sort(p => p.file.name); // 按文件名排序

// 输出带有链接的章节
for (let page of pages) {
  dv.paragraph(`- [[${page.file.path}|${page.file.name}]]`);
}

```
```dataviewjs
// 获取当前文件夹路径（例如 "B_知识"）
const currentFolder = dv.current().file.folder;

// 查询当前文件夹下的所有文件
const pages = dv.pages(`"${currentFolder}"`);

// 生成章节列表并按名称排序
let sortedPages = pages
  .where(p => p.file.name.includes("1.1"))
  .sort(p => p.file.name);

// 输出带有链接的章节
for (let page of sortedPages) {
  dv.paragraph(`- [[${page.file.path}|${page.file.name}]]`);
}


```
```dataviewjs
// 获取当前文件夹路径（例如 "B_知识"）
const currentFolder = dv.current().file.folder;

// 查询当前文件夹下的所有文件
const pages = dv.pages(`"${currentFolder}"`);

// 生成章节列表并按名称排序
let sortedPages = pages
  .where(p => p.file.name.includes("1.1"))
  .sort(p => p.file.name);

// 输出带有链接的章节
for (let page of sortedPages) {
  dv.paragraph(`- [[${page.file.path}|${page.file.name}]]`);
}


```
