# AstrBot Launcher v1.0.0

**发布日期**: 2026-06-18
**最低系统**: macOS 26 Tahoe (Apple Silicon)
**架构**: arm64 (Apple Silicon)

## 📦 下载

| 文件 | 大小 | SHA256 |
|------|------|--------|
| `AstrbotLauncher-1.0.0.dmg` | 802 KB | `37e4dafe06fdae3c434f45dc997d2fd72e935bde6881800182f6290c018052ce` |
| `AstrbotLauncher-1.0.0-macOS.zip` | 537 KB | `ea3b746ba6e78720565249dea104e032b7df6cd689d4c340020b0f71cd9d0e52` |

## ✨ 主要功能

- **一键管理** 三个核心服务：AstrBot（QQ 机器人）、NapCat（QQ 协议端）、Shipyard（Agent 调度平台）
- **实时日志** 监听（文件 / docker logs 双模式，行缓冲 + 批量 flush）
- **智能 URL 检测** 从日志自动提取 WebUI URL（含 token）
- **daemon 化** AstrBot — 关闭 app 不影响 AstrBot 运行
- **菜单栏常驻** — app 关闭后菜单栏图标仍可访问
- **Liquid Glass** UI — SwiftUI 原生 Liquid Glass 设计

## 🚀 安装

### DMG（推荐）
1. 双击 `AstrbotLauncher-1.0.0.dmg`
2. 拖拽 `AstrbotLauncher.app` 到 `/Applications`
3. 在 Launchpad 打开 "AstrBot Launcher"
4. 首次启动如遇 Gatekeeper 拦截，在"系统设置 → 隐私与安全性"点击"仍要打开"

### ZIP
1. 解压 `AstrbotLauncher-1.0.0-macOS.zip`
2. 移动 `AstrbotLauncher.app` 到 `/Applications`
3. 启动 app

## 📋 首次使用

1. 启动 AstrBot Launcher
2. 打开 ⚙️ 设置
3. 在 "Docker 容器" 部分选择 NapCat / Shipyard 容器
4. 设置 AstrBot WebUI 端口（默认 6185）
5. 配置 AstrBot 日志路径（默认 `~/data/logs/astrbot.log`）
6. 返回主窗口，点工具栏 ▶ **启动** 即可一键启动全部服务

## 🔧 系统要求

- **macOS 26 Tahoe** 或更高
- **Apple Silicon** (M1/M2/M3/M4)
- **Docker Desktop** 已安装并运行
- **AstrBot** 通过 `uv tool install astrbot` 安装
- **NapCat / Shipyard** 通过 `docker compose` 部署

## 📝 已知问题

- 服务状态切换瞬时按钮图标可能闪烁
- WebUI 按钮位置在 ServiceDetailView（如需在工具栏加回，需手动开关，目前通过详情页访问）

## 📮 反馈

GitHub Issues / 项目地址：[你的 GitHub 仓库 URL]

---

**Full Changelog**: 见 `CHANGELOG.md`
