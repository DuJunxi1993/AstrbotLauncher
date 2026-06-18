# AstrBot Launcher v1.0.2

**发布日期**: 2026-06-18
**最低系统**: macOS 26 Tahoe (Apple Silicon)
**架构**: arm64 (Apple Silicon)

## 📦 下载

| 文件 | 大小 | SHA256 |
|------|------|--------|
| `AstrbotLauncher-1.0.2.dmg` | 812 KB | `2717d211f06364d3e73eb78a1baa0f2497e834af15ad1370b6efdcbd60f387a1` |
| `AstrbotLauncher-1.0.2-macOS.zip` | 548 KB | `fe0edffdd73ffcf4c3f864e12b609ed8add598c9b9827aaf89b8923134a1a361` |

## 🔴 紧急修复 v1.0.1 → v1.0.2

### 关键崩溃修复
**问题**：v1.0.0 / v1.0.1 启用 `.toolbar(id:)` + `customizationBehavior()` 尝试实现 Finder 风格工具栏自定义。**但 macOS 26.5.1 在应用启动时尝试应用旧版 UserDefaults 残留的 customization 状态，会触发 `AppKitToolbarStrategy.applyItemCustomizations` 内部断言崩溃**（`EXC_BREAKPOINT`）。

**影响**：所有从 v1.0.0 / v1.0.1 升级的用户的 UserDefaults 都有残留，**必崩**。

**修复**：
- 彻底移除 `.toolbar(id:)` 和所有 `customizationBehavior()` 调用
- 改用普通 `.toolbar { ... }`（5 个固定 items，无 customization）
- 启动时主动清理 `NSNavToolbarCustomization-*` 和 `NSToolbar Identifier *` UserDefaults keys
- 不再添加 `ToolbarCommands()` 到 scene commands

### 妥协：Finder 风格工具栏自定义
**v1.0.0/v1.0.1 的工具栏自定义功能（右键 → Customize Toolbar）已移除**。这是 macOS 26.5.1 上 SwiftUI 的根本问题，强行使用会崩溃。

后续 v1.1.x 会用其他方式（自定义 NSToolbar 或纯 SwiftUI Layout）实现类似体验。

## ✅ 保留的功能

| 功能 | 状态 |
|------|------|
| 启停切换 | ✅ |
| 刷新 | ✅ |
| 打开 WebUI | ✅ |
| 数据目录 | ✅ |
| 设置 | ✅ |
| Sidebar 拖动排序 | ✅ |
| 日志查看 / 暂停 / 清空 | ✅ |
| 状态栏 + 详情头部状态指示 | ✅ |
| Sidebar 服务顺序持久化 | ✅ |

## ✨ 主要功能

- **一键管理** 三个核心服务：AstrBot（QQ 机器人）、NapCat（QQ 协议端）、Shipyard（Agent 调度平台）
- **实时日志** 监听（文件 / docker logs 双模式，行缓冲 + 批量 flush）
- **智能 URL 检测** 从日志自动提取 WebUI URL（含 token）
- **daemon 化** AstrBot — 关闭 app 不影响 AstrBot 运行
- **菜单栏常驻** — app 关闭后菜单栏图标仍可访问
- **Liquid Glass** UI — SwiftUI 原生 Liquid Glass 设计

## 🚀 安装

### DMG（推荐）
1. 双击 `AstrbotLauncher-1.0.2.dmg`
2. 拖拽 `AstrbotLauncher.app` 到 `/Applications`
3. **重要**：从 `/Applications` 删除旧版 `AstrbotLauncher.app`（避免旧 UserDefaults 残留）
4. 在 Launchpad 打开 "AstrBot Launcher"
5. 首次启动如遇 Gatekeeper 拦截，在"系统设置 → 隐私与安全性"点击"仍要打开"

### ZIP
1. 解压 `AstrbotLauncher-1.0.2-macOS.zip`
2. 移动 `AstrbotLauncher.app` 到 `/Applications`，**先删除旧版**
3. 启动 app

## 🔧 系统要求

- **macOS 26 Tahoe** 或更高
- **Apple Silicon** (M1/M2/M3/M4)
- **Docker Desktop** 已安装并运行
- **AstrBot** 通过 `uv tool install astrbot` 安装
- **NapCat / Shipyard** 通过 `docker compose` 部署

## 📮 反馈

GitHub Issues / 项目地址：[你的 GitHub 仓库 URL]
