# William's Blog

[![Hexo](https://img.shields.io/badge/Hexo-8.1.1-orange)](https://hexo.io/)
[![Node.js](https://img.shields.io/badge/Node.js-20+-green)](https://nodejs.org/)
[![GitHub Pages](https://img.shields.io/badge/GitHub-Pages-blue)](https://pages.github.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

> **Walk steps step by step** - William Xie's Technical Blog

一个专注于 iOS 开发、音视频技术、云计算等技术的个人博客，记录学习与实践的心路历程。

## ✨ 特性

- 🚀 **现代化技术栈** - Hexo 8.x + Node.js 20+
- 🎨 **美观主题** - Maple 主题，响应式设计
- 📱 **移动端优化** - 完美支持移动设备
- 🔍 **SEO 友好** - 搜索引擎优化
- ⚡ **自动部署** - GitHub Actions CI/CD
- 📝 **Markdown 支持** - 丰富的写作体验
- 🏷️ **标签分类** - 完善的文章组织
- 🌙 **代码高亮** - Prism.js 语法高亮

## 📋 目录

- [快速开始](#-快速开始)
- [本地开发](#-本地开发)
- [写作指南](#-写作指南)
- [部署说明](#-部署说明)
- [项目结构](#-项目结构)
- [维护指南](#-维护指南)
- [许可证](#-许可证)

## 🚀 快速开始

### 环境要求

- Node.js 18+
- Git
- npm 或 yarn

### 克隆项目

```bash
git clone https://github.com/williamxiewz/williamxiewz.github.io.git
cd williamxiewz.github.io
```

### 安装依赖

```bash
# 使用 npm
npm install

# 或使用 yarn
yarn install

# 或使用 bun（推荐）
bun install
```

### 本地预览

```bash
# 启动本地服务器
npm run server

# 或使用 Hexo 命令
hexo server
```

访问 `http://localhost:4000` 查看博客。

## 🛠️ 本地开发

### 常用命令

```bash
# 生成静态文件
npm run build
# 或
hexo generate

# 清理缓存
npm run clean
# 或
hexo clean

# 部署到 GitHub Pages
npm run deploy
# 或
hexo deploy

# 新建文章
hexo new post "文章标题"

# 新建页面
hexo new page "页面名称"
```

### 开发工作流

1. **创建新文章**
   ```bash
   hexo new post "iOS 新特性探索"
   ```

2. **编辑文章**
   - 文章保存在 `source/_posts/` 目录
   - 使用 Markdown 格式写作
   - 支持 Front-matter 元数据

3. **本地预览**
   ```bash
   hexo server
   ```

4. **提交更改**
   ```bash
   git add .
   git commit -m "Add: 新文章标题"
   git push origin master
   ```

5. **自动部署**
   - GitHub Actions 会自动触发部署
   - 几分钟后访问博客查看更新

## ✍️ 写作指南

### 文章格式

```markdown
---
title: 文章标题
date: 2024-01-01 12:00:00
tags:
  - iOS
  - Swift
categories:
  - 移动开发
---

这里是文章内容...

## 二级标题

正文内容...

<!-- more -->  # 阅读更多分割线
```

### 写作规范

- **文件名**：使用英文，单词间用连字符 `-`
- **标题**：简洁明了，体现核心内容
- **标签**：选择相关技术标签
- **分类**：按技术领域分类
- **摘要**：使用 `<!-- more -->` 分割摘要

### 资源管理

- **图片**：放在 `source/img/` 或文章同名文件夹
- **附件**：放在 `source/downloads/` 目录
- **引用**：使用相对路径引用资源

## 🚀 部署说明

### 自动部署（推荐）

1. **推送代码**
   ```bash
   git add .
   git commit -m "Update: 提交信息"
   git push origin master
   ```

2. **自动触发**
   - GitHub Actions 会自动运行
   - 生成静态文件并部署到 GitHub Pages
   - 部署完成后可访问博客

### 手动部署

```bash
# 生成静态文件
hexo generate

# 部署到 GitHub Pages
hexo deploy
```

### 部署配置

- **仓库**: `williamxiewz/williamxiewz.github.io`
- **分支**: `master` (源码) → GitHub Pages (自动部署)
- **域名**: `williamxiewz.github.io`

## 📁 项目结构

```
williamxiewz.github.io/
├── .github/
│   └── workflows/          # GitHub Actions 配置
├── public/                 # 生成的静态文件 (自动生成)
├── scaffolds/              # 文章和页面模板
├── source/                 # 源文件目录
│   ├── _posts/            # 文章目录
│   ├── about/             # 关于页面
│   ├── apps/              # 应用页面
│   ├── img/               # 图片资源
│   └── CNAME              # 域名配置
├── themes/                 # 主题目录
│   └── maple/             # Maple 主题
├── _config.yml            # Hexo 配置文件
├── package.json           # 项目配置和依赖
├── .gitignore            # Git 忽略文件
└── README.md             # 项目说明 (本文档)
```

## 🔧 维护指南

### 依赖更新

```bash
# 更新所有依赖
npm update

# 更新特定包
npm install hexo@latest
```

### 主题更新

```bash
# 更新 Maple 主题
npm install hexo-theme-maple@latest
```

### 备份策略

- **源码备份**: GitHub 仓库自动备份
- **数据库备份**: `db.json` 自动生成
- **配置备份**: `_config.yml` 版本控制

### 故障排除

**常见问题:**

1. **页面无法访问**
   - 检查 GitHub Pages 设置
   - 确认 Actions 运行成功

2. **样式异常**
   - 清理缓存: `hexo clean`
   - 重新生成: `hexo generate`

3. **依赖问题**
   - 删除 `node_modules/`
   - 重新安装: `npm install`

### 性能监控

- **构建时间**: GitHub Actions 显示
- **页面大小**: 使用 Lighthouse 测试
- **加载速度**: 监控 Core Web Vitals

## 📊 统计信息

- **文章数量**: 50+ 篇技术文章
- **分类**: iOS 开发、音视频、云计算等
- **标签**: 30+ 个技术标签
- **访问量**: 通过 Google Analytics 统计

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支: `git checkout -b feature/新功能`
3. 提交更改: `git commit -m 'Add: 新功能描述'`
4. 推送分支: `git push origin feature/新功能`
5. 创建 Pull Request

## 📄 许可证

本项目采用 [MIT License](LICENSE) 开源协议。

## 👨‍💻 作者

**William Xie**
- 📧 Email: [联系邮箱]
- 📱 微信: williamxiewz
- 🐙 GitHub: [@williamxiewz](https://github.com/williamxiewz)
- 🌐 博客: [williamxiewz.github.io](https://williamxiewz.github.io)

---

⭐ 如果这个项目对你有帮助，请给它一个 Star！

最后更新: 2024年12月
