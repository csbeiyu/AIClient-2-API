# Docker 快速入门

> 5 分钟上手 Docker 部署 AIClient-2-API

---

## 🐳 什么是 Docker？

Docker 是一个容器化平台，让你可以：
- 把应用和依赖打包在一起
- 在任何地方运行，保证环境一致
- 快速部署、更新、回滚

**类比**：
- **传统部署** = 自己买菜做饭（要准备所有食材）
- **Docker 部署** = 点外卖（打开就能吃）

---

## 📦 核心概念

| 概念 | 说明 | 类比 |
|------|------|------|
| **镜像 (Image)** | 应用的模板/蓝图 | 菜谱 |
| **容器 (Container)** | 运行中的镜像实例 | 做好的菜 |
| **Dockerfile** | 构建镜像的指令 | 做菜的步骤 |
| **Docker Compose** | 管理多个容器的工具 | 套餐菜单 |

---

## 🚀 快速开始

### 步骤 1：检查 Docker 是否安装

```bash
docker --version
docker compose version
```

看到版本号就说明装好了。

**没装？** 看下面的安装指南。

---

### 步骤 2：进入项目目录

```bash
cd ~/Desktop/AIClient
```

---

### 步骤 3：构建镜像

```bash
docker compose build
```

**这个过程会：**
1. 下载 Node.js 基础镜像
2. 安装项目依赖
3. 编译 Go sidecar
4. 打包应用代码

**首次构建约 5-10 分钟**，后续构建会快很多。

---

### 步骤 4：启动服务

```bash
docker compose up -d
```

`-d` 表示后台运行（不占用终端）。

---

### 步骤 5：检查状态

```bash
# 查看容器状态
docker compose ps

# 查看日志
docker compose logs -f
```

看到 `Up (healthy)` 就说明运行正常。

---

### 步骤 6：访问服务

浏览器打开：`http://localhost:3000`

点击「一键登录」即可。

---

## 🛠️ 常用命令

| 命令 | 说明 |
|------|------|
| `docker compose up -d` | 启动服务 |
| `docker compose down` | 停止并删除容器 |
| `docker compose ps` | 查看容器状态 |
| `docker compose logs -f` | 查看实时日志 |
| `docker compose restart` | 重启服务 |
| `docker compose build` | 重新构建镜像 |
| `docker compose pull` | 拉取最新镜像 |

---

## 📁 数据持久化

Docker 容器删除后数据会丢失，所以需要**卷映射**：

```yaml
volumes:
  - ./configs:/app/configs    # 配置文件
  - ./logs:/app/logs          # 日志文件
```

这样即使容器删除，配置文件和日志也会保留在本地。

---

## 🔄 更新服务

### 方式一：自动更新脚本

```bash
cd ~/Desktop/AIClient
./check-update.sh --update
```

### 方式二：手动更新

```bash
cd ~/Desktop/AIClient

# 拉取最新代码
git pull

# 重新构建镜像
docker compose build --no-cache

# 重启服务
docker compose up -d --force-recreate
```

---

## 🚨 常见问题

### 1. `command not found: docker`

**原因**：Docker 没装

**解决**：
```bash
# macOS (Homebrew)
brew install --cask docker

# 然后打开 Docker Desktop 应用
```

### 2. 端口被占用

**错误**：`Bind for 0.0.0.0:3000 failed: port is already allocated`

**解决**：
```bash
# 查找占用端口的进程
lsof -i :3000

# 停止进程
kill -9 <PID>

# 或者修改 docker-compose.yml 中的端口映射
```

### 3. 构建太慢

**原因**：网络问题，下载依赖慢

**解决**：配置 Docker 镜像源

**macOS**：
1. 打开 Docker Desktop
2. 设置 → Docker Engine
3. 添加镜像源：
```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://registry.docker-cn.com"
  ]
}
```

### 4. 磁盘空间不足

**解决**：清理无用镜像和容器
```bash
# 清理所有未使用的资源
docker system prune -a

# 查看磁盘使用
docker system df
```

---

## 📊 监控和调试

### 查看日志

```bash
# 实时日志
docker compose logs -f

# 最近 100 行
docker compose logs --tail=100

# 特定服务
docker compose logs aiclient2api
```

### 进入容器

```bash
# 进入容器内部
docker compose exec aiclient2api sh

# 查看容器内文件
docker compose exec aiclient2api ls -la /app
```

### 查看资源使用

```bash
# CPU、内存使用率
docker stats aiclient2api
```

---

## 🎯 最佳实践

### 1. 定期清理

```bash
# 每周清理一次
docker system prune -f
```

### 2. 使用 .dockerignore

项目中的 `.dockerignore` 文件会排除不需要的文件：
```
node_modules
.git
*.md
```

### 3. 健康检查

docker-compose.yml 中已配置健康检查：
```yaml
healthcheck:
  test: ["CMD", "node", "healthcheck.js"]
  interval: 30s
  timeout: 3s
  retries: 3
```

### 4. 日志轮转

防止日志文件过大：
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

---

## 📚 学习资源

- [Docker 官方文档](https://docs.docker.com/)
- [Docker Compose 文档](https://docs.docker.com/compose/)
- [Docker 入门教程](https://www.docker.com/101-tutorial/)

---

## ⚠️ 安全提示

- 不要在公网暴露 Docker API
- 定期更新基础镜像
- 使用非 root 用户运行容器
- 不要将敏感信息硬编码在 Dockerfile 中

---

**最后更新**：2026-03-13  
**维护者**：小徐 👨‍💻
