#!/bin/bash
# AstrBot Launcher - 快速运行（开发模式）
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

CONFIG="${CONFIG:-debug}"

if [ ! -f ".build/$CONFIG/AstrbotLauncher" ]; then
    echo "==> 编译 ($CONFIG)..."
    swift build -c "$CONFIG"
fi

echo "==> 启动 AstrBot Launcher..."
.build/$CONFIG/AstrbotLauncher
