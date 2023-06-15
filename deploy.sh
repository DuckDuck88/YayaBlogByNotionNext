#!/bin/bash

# 输入参数：notion-blog版本号
version=$1
# 默认应用版本
default_version="latest"

# 如果没有指定版本参数，则使用默认版本
if [ -z "$version" ]; then
  version=$default_version
fi

# 构建镜像
docker build -t notion-blog:$version .

# 检查同名容器是否存在，存在则停用并删除
container_name="notion-blog"
if [[ $(docker ps -a --filter "name=$container_name" --format "{{.Names}}") == $container_name ]]; then
    docker stop $container_name
    docker rm $container_name
fi

# 启动容器并将日志输出到指定位置
docker run -d --name $container_name \
  -v $(pwd)/blog.config.js:/app/blog.config.js \
  -p 3000:3000 \
  --log-driver=json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  --log-opt path=/var/log/notion-blog/notion-blog.log \
  notion-blog:$version

