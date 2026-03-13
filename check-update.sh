#!/bin/bash

# AIClient-2-API 更新检查脚本
# 用法：./check-update.sh [--update]

REPO_URL="https://github.com/justlovemaki/AIClient-2-API"
LOCAL_VERSION=$(cat VERSION 2>/dev/null || echo "unknown")

echo "🔍 检查 AIClient-2-API 更新..."
echo "📦 当前版本：$LOCAL_VERSION"

# 获取远程最新版本
REMOTE_VERSION=$(curl -s https://raw.githubusercontent.com/justlovemaki/AIClient-2-API/main/VERSION 2>/dev/null || echo "unknown")
echo "🆕 最新版本：$REMOTE_VERSION"

if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
    echo "✅ 已是最新版本"
    exit 0
fi

echo "⚠️  发现新版本！"

if [ "$1" = "--update" ]; then
    echo "🔄 开始更新..."
    
    # 备份配置
    if [ -d "configs" ]; then
        cp -r configs configs.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # git pull
    git fetch origin main
    git reset --hard origin/main
    
    # 重新构建 Docker
    echo "🐳 重新构建 Docker 镜像..."
    docker-compose build --no-cache
    
    # 重启服务
    echo "🚀 重启服务..."
    docker-compose up -d --force-recreate
    
    echo "✅ 更新完成！"
else
    echo ""
    echo "运行 './check-update.sh --update' 执行自动更新"
    echo "或手动执行：git pull && docker-compose build && docker-compose up -d"
fi
