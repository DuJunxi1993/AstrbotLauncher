# AstrBot Launcher

启动与管理 [AstrBot](https://github.com/SillyGods/AstrBot)（QQ 机器人）的多平台图形化管理工具。

本仓库是一个 **umbrella 仓库**，按分支区分两个完全独立的子项目：

| 分支 | 平台 | 技术栈 | 当前版本 | 说明 |
|------|------|--------|---------|------|
| [`macos`](../../tree/macos) | macOS 26+ (Tahoe) | Swift 6 / SwiftUI | v1.0.3 | 一键管理 AstrBot + NapCat/Shipyard 容器，支持菜单栏常驻、登录项自启 |
| [`windows-wsl`](../../tree/windows-wsl) | Windows 10/11 + WSL | Python 3.8+ / tkinter | v0.1.1 | 通过 WSL 管理 AstrBot + NapCat QQ 机器人，PyInstaller 打包 |

两个项目目的相同，但**实现、构建、发布完全独立**，互不依赖、各自演进。

## 下载

请前往 [Releases](../../releases) 页面选择对应平台的安装包：
- **macOS**：`.dmg` 或 `.zip`
- **Windows/WSL**：`.exe`（已用 PyInstaller 打包，含 Python 运行时）

## 快速开始

请切换到对应平台分支查看详细说明：

- macOS 用户：[**macos**](../../tree/macos) 分支的 `README.md`
- Windows/WSL 用户：[**windows-wsl**](../../tree/windows-wsl) 分支的 `README.md`

## 致谢

- [AstrBot](https://github.com/SillyGods/AstrBot) - QQ 机器人框架
- [NapCat](https://github.com/NapNeko/NapCat-QQBot) - QQ 协议客户端

## 许可

本仓库及两个子项目均基于 [MIT License](LICENSE) 开源。详见 [`LICENSE`](LICENSE) 文件。
