#!/bin/bash

# 指定新版本号作为脚本参数
NEW_VERSION=$1

# 检查容器是否正在运行
if docker ps -f "name=notion-blog" --format '{{.Names}}' | grep -q "notion-blog"; then
    echo "Stopping notion-blog container..."
    # 停止当前版本的容器
    docker stop notion-blog
else
    echo "No running notion-blog container found."
fi

# 检查容器是否存在
if docker ps -a -f "name=notion-blog" --format '{{.Names}}' | grep -q "notion-blog"; then
    echo "Removing notion-blog container..."
    # 删除当前版本的容器
    docker rm notion-blog
else
    echo "No notion-blog container found."
fi

# 构建新版本镜像
docker build -t notion-blog:$NEW_VERSION .

# 启动新版本容器
docker run -d --name notion-blog -v $(pwd)/blog.config.js:/app/blog.config.js -p 3000:3000 notion-blog:$NEW_VERSION
