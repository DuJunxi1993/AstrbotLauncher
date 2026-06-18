# AstrBot Launcher v1.0.3

**发布日期**: 2026-06-18
**最低系统**: macOS 26 Tahoe (Apple Silicon)
**架构**: arm64 (Apple Silicon)

## 📦 下载

| 文件 | 大小 | SHA256 |
|------|------|--------|
| `AstrbotLauncher-1.0.3.dmg` | 557 KB | `3f32ca806f37abf97fb36672db200fd61ce5c3d8ae2f7ac6708eb948284440f6` |
| `AstrbotLauncher-1.0.3-macOS.zip` | 549 KB | `5b7278d5f4b90cc3ef0e31569d7f515423ccb78686030ac5cfc54ffca644b805` |

## 🔄 v1.0.2 → v1.0.3 变更

### 改进
- **工具栏布局** — 在启停按钮和右侧 4 个按钮之间增加可调间距
  - 实现方式：`ToolbarItem(placement: .principal) { Color.clear.frame(maxWidth: .infinity) }` 填充中间区域
  - 右侧 4 个按钮（刷新 / WebUI / 数据目录 / 设置）从 `.automatic` 改为 `.primaryAction`（挤在右侧）
  - 视觉效果：左侧启停按钮 + 中间大片空白 + 右侧 4 个按钮聚集

## 保留所有 v1.0.2 修复

- v1.0.2 已彻底移除 `.toolbar(id:)` / `customizationBehavior()` 修复 macOS 26.5.1 启动崩溃
- 启动时主动清理旧 UserDefaults keys
- 5 个固定 toolbar items，无 customization

## 保留所有 v1.0.1 功能

- Sidebar 拖动排序 + 顺序持久化
- 启停 / 刷新 / WebUI / 数据目录 / 设置
- 日志查看 / 暂停 / 清空（只清当前 service）
- Liquid Glass UI
- daemon 化 AstrBot
- 菜单栏常驻

## 🚀 安装

### DMG（推荐）
1. 双击 `AstrbotLauncher-1.0.3.dmg`
2. 拖拽 `AstrbotLauncher.app` 到 `/Applications`（替换旧版）
3. 首次启动如遇 Gatekeeper 拦截，在"系统设置 → 隐私与安全性"点击"仍要打开"

### ZIP
1. 解压 `AstrbotLauncher-1.0.3-macOS.zip`
2. 移动 `AstrbotLauncher.app` 到 `/Applications`（替换旧版）
3. 启动 app

## 🔧 系统要求

- **macOS 26 Tahoe** 或更高
- **Apple Silicon** (M1/M2/M3/M4)
- **Docker Desktop** 已安装并运行
- **AstrBot** 通过 `uv tool install astrbot` 安装
- **NapCat / Shipyard** 通过 `docker compose` 部署

## 📮 反馈

GitHub Issues / 项目地址：[你的 GitHub 仓库 URL]
