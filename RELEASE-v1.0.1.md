# AstrBot Launcher v1.0.1

**发布日期**: 2026-06-18
**最低系统**: macOS 26 Tahoe (Apple Silicon)
**架构**: arm64 (Apple Silicon)

## 📦 下载

| 文件 | 大小 | SHA256 |
|------|------|--------|
| `AstrbotLauncher-1.0.1.dmg` | 558 KB | `2c778d9709a27188c0ede3c7c1c370eacfc1b82924f313e186910a3c30da07b1` |
| `AstrbotLauncher-1.0.1-macOS.zip` | 550 KB | `a025805f11b5961182f1de6855fa041c27680435461a6f4585b207f97537548f` |

## 🔄 v1.0.0 → v1.0.1 变更

### 修复
- **Sidebar 状态点重复** — 移除 sidebar 项目的红绿状态点（状态栏和详情头部已有指示）
- **Toolbar customization 崩溃** — 启动时清理旧 UserDefaults state（防崩溃 v1.0.0 已知问题再次发生）
- **Service selection tint** — 改用 `CustomizableToolbarContent` 协议 + `customizationBehavior()` modifier，正确的 macOS 26 API

### 新增
- **Sidebar 拖动排序** — `ForEach.onMove` 让服务项像 Finder 一样可拖动重排
- **Finder 风格工具栏自定义** — 菜单栏 View → Customize Toolbar，可拖入 / 拖出 / 重排工具栏 items
- **Service 顺序持久化** — 用户的 sidebar 顺序保存到 UserDefaults，重启后保持

### 优化
- **日志性能** — `filteredLines` 改 `@State` 缓存，避免每次 render O(n) 扫描
- **Pause 不丢失历史** — 用 `LogWatcher.isPaused` 标志，暂停时保留已显示的日志（旧版 `stop()` 会清空）
- **Per-service clear** — 清空按钮只清当前 service 的日志（不影响其他服务）
- **scrollTo 去掉 withAnimation** — 避免每行日志触发 layout pass

### 改进
- **设置页布局修复** — 修复 Docker Picker 宽度不一致、WebUI 端口显示格式
- **状态栏** — 移除矩形背景，与主内容在同一层
- **主题集成** — 完整 Liquid Glass 适配

## ✨ 主要功能（v1.0.0 起）

- **一键管理** 三个核心服务：AstrBot（QQ 机器人）、NapCat（QQ 协议端）、Shipyard（Agent 调度平台）
- **实时日志** 监听（文件 / docker logs 双模式，行缓冲 + 批量 flush）
- **智能 URL 检测** 从日志自动提取 WebUI URL（含 token）
- **daemon 化** AstrBot — 关闭 app 不影响 AstrBot 运行
- **菜单栏常驻** — app 关闭后菜单栏图标仍可访问
- **Liquid Glass** UI — SwiftUI 原生 Liquid Glass 设计

## 🚀 安装

### DMG（推荐）
1. 双击 `AstrbotLauncher-1.0.1.dmg`
2. 拖拽 `AstrbotLauncher.app` 到 `/Applications`
3. 在 Launchpad 打开 "AstrBot Launcher"
4. 首次启动如遇 Gatekeeper 拦截，在"系统设置 → 隐私与安全性"点击"仍要打开"

### ZIP
1. 解压 `AstrbotLauncher-1.0.1-macOS.zip`
2. 移动 `AstrbotLauncher.app` 到 `/Applications`
3. 启动 app

## 📋 首次使用

1. 启动 AstrBot Launcher
2. 打开 ⚙️ 设置
3. 在 "Docker 容器" 部分选择 NapCat / Shipyard 容器
4. 设置 AstrBot WebUI 端口（默认 6185）
5. 配置 AstrBot 日志路径（默认 `~/data/logs/astrbot.log`）
6. 返回主窗口，点工具栏 ▶ **启动** 即可一键启动全部服务
7. 在 sidebar 拖动服务项可调整顺序
8. 右键工具栏 → Customize Toolbar 自定义工具栏 items

## 🔧 系统要求

- **macOS 26 Tahoe** 或更高
- **Apple Silicon** (M1/M2/M3/M4)
- **Docker Desktop** 已安装并运行
- **AstrBot** 通过 `uv tool install astrbot` 安装
- **NapCat / Shipyard** 通过 `docker compose` 部署

## 📮 反馈

GitHub Issues / 项目地址：[你的 GitHub 仓库 URL]

---

**Full Changelog**: 见 `CHANGELOG.md`
