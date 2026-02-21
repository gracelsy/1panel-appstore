# TinyAuth

TinyAuth 是一个轻量级的 OAuth2 / OIDC 认证代理，适合为已有的 Web 应用、面板或服务添加登录保护。你可以将它部署在应用之前，通过标准的身份提供商（如 Casdoor、Keycloak、Auth0 等）实现单点登录（SSO）。
## 使用前请查看官方文档

## 功能特性

* 支持 OAuth2 / OpenID Connect 协议
* 支持多身份提供商配置
* 可保护现有 Web 服务（无需修改应用本身）
* 简单的反向代理模式
* 支持多种回调和重定向策略

## 快速开始

### 1. 部署 TinyAuth

使用 Docker 运行：

```bash
docker run -d \
  --name=tinyauth \
  -p 8080:8080 \
  -v $(pwd)/config.yml:/app/config.yml \
  ghcr.io/tinyauth/tinyauth:latest
```

### 2. 配置示例

在 `config.yml` 中配置认证提供商（例如 Casdoor）：

```yaml
server:
  port: 8080

providers:
  - id: casdoor
    name: Casdoor
    client_id: your-client-id
    client_secret: your-client-secret
    issuer: https://auth.example.com
    redirect_url: https://tinyauth.example.com/callback
```

### 3. Nginx 反向代理示例

```nginx
server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
```

### 4. 登录流程

1. 访问受保护的应用（如 `app.example.com`）
2. TinyAuth 会跳转到认证提供商（如 Casdoor）登录
3. 登录成功后跳转回应用

## 配置参数

常见参数：

| 环境变量 | CLI 标志 | 描述 | 默认值 | 必需 |
|----------|----------|------|--------|------|
| `PROVIDERS_[ID]_AUTH_URL` | `--providers-[id]-auth-url` | OAuth 授权 URL。 | `` | 是 |
| `PROVIDERS_[ID]_CLIENT_ID` | `--providers-[id]-client-id` | OAuth 客户端 ID。 | `` | 是 |
| `PROVIDERS_[ID]_CLIENT_SECRET` | `--providers-[id]-client-secret` | OAuth 客户端密钥。 | `` | 是 |
| `PROVIDERS_[ID]_CLIENT_SECRET_FILE` | `--providers-[id]-client-secret-file` | 包含客户端密钥的文件路径。 | `` | 否 |
| `PROVIDERS_[ID]_INSECURE_SKIP_VERIFY` | `--providers-[id]-insecure-skip-verify` | 跳过 TLS 证书验证。 | `` | 否 |
| `PROVIDERS_[ID]_NAME` | `--providers-[id]-name` | OAuth 提供商的名称。 | `` | 否 |
| `PROVIDERS_[ID]_REDIRECT_URL` | `--providers-[id]-redirect-url` | OAuth 重定向 URL。 | `` | 是 |
| `PROVIDERS_[ID]_SCOPES` | `--providers-[id]-scopes` | OAuth 权限范围列表。 | `` | 是 |
| `PROVIDERS_[ID]_TOKEN_URL` | `--providers-[id]-token-url` | OAuth 令牌 URL。 | `` | 是 |
| `PROVIDERS_[ID]_USER_INFO_URL` | `--providers-[id]-user-info-url` | 获取用户信息的 URL。 | `` | 是 |


## 参考链接

* [TinyAuth 文档](https://tinyauth.app/docs)
* [OAuth2 Proxy](https://oauth2-proxy.github.io/oauth2-proxy/)（类似工具）
* [Casdoor](https://casdoor.org/)（身份提供商示例）