# 项目修改记录

## 修改日期：2026-03-13

## 修改内容：去除密码登录功能

### 修改文件

#### 1. `src/ui-modules/auth.js`

**修改内容：**
- `validateCredentials()` 函数：现在始终返回 `true`，不再验证密码
- `handleLoginRequest()` 函数：移除了密码验证逻辑，直接生成 token 并返回成功

**修改前：**
```javascript
export async function validateCredentials(password) {
    const storedPassword = await readPasswordFile();
    const isValid = storedPassword && password === storedPassword;
    return isValid;
}
```

**修改后：**
```javascript
export async function validateCredentials(password) {
    logger.info('[Auth] Password validation bypassed - allowing all logins');
    return true;
}
```

#### 2. `static/login.html`

**修改内容：**
- 移除了密码输入框
- 改为"一键登录"按钮
- 页面加载时自动尝试登录
- 登录请求不再发送密码字段

**修改前：**
- 用户需要输入密码
- 提交表单时验证密码

**修改后：**
- 无需密码
- 点击按钮或页面加载时自动登录

### 安全警告

⚠️ **此修改移除了所有身份验证保护！**

修改后的系统：
- ✅ 任何人都可以登录
- ✅ 无需任何凭证
- ✅ 保留速率限制（防止滥用）
- ❌ **不适合生产环境**
- ❌ **不适合公网访问**

### 使用场景

此修改仅适用于：
- 本地开发环境
- 受信任的内网环境
- 测试和调试目的

### 恢复密码保护

如需恢复密码保护：
1. 在 `configs/pwd` 文件中设置密码
2. 恢复 `src/ui-modules/auth.js` 中的原始验证逻辑
3. 恢复 `static/login.html` 中的密码输入框

### Docker 部署

使用以下命令构建和运行：

```bash
cd ~/Desktop/AIClient

# 构建镜像
docker compose build

# 启动服务
docker compose up -d

# 查看日志
docker compose logs -f
```

访问地址：http://localhost:3000
