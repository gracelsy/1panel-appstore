# RustDesk API


本项目使用 Go 实现了 RustDesk 的 API网页控制台，并包含了 Web Admin 和 Web 客户端。


<div align=center>
<img src="https://img.shields.io/badge/golang-1.22-blue"/>
<img src="https://img.shields.io/badge/gin-v1.9.0-lightBlue"/>
<img src="https://img.shields.io/badge/gorm-v1.25.7-green"/>
<img src="https://img.shields.io/badge/swag-v1.16.3-yellow"/>
<img src="https://goreportcard.com/badge/github.com/lejianwen/rustdesk-api/v2"/>
<img src="https://github.com/lejianwen/rustdesk-api/actions/workflows/build.yml/badge.svg"/>
</div>

### 端口开放

RustDesk-API默认开放以下端口，不建议修改。
- 21114 (TCP): 用于API网页控制台。
- 21115 (TCP): 用于 NAT 类型测试。 
- 21116 (TCP): 用于 TCP 打洞和连接服务。
- 21116 (UDP): 用于 ID 注册和心跳服务。
- 21118 (TCP): 用于支持网页客户端。
- 21117 (TCP): 用于中继服务。
- 21119 (TCP): 用于支持网页客户端。

### 特性

- PC端API
    - 个人版API
    - 登录
    - 地址簿
    - 群组
    - 授权登录
      - 支持`github`, `google` 和 `OIDC` 登录，
      - 支持`web后台`授权登录
      - 支持`LDAP`(AD和OpenLDAP已测试), 如果API Server配置了LDAP
    - i18n
- Web Admin
    - 用户管理
    - 设备管理
    - 地址簿管理
    - 标签管理
    - 群组管理
    - Oauth 管理
    - 配置LDAP, 配置文件或者环境变量
    - 登录日志
    - 链接日志
    - 文件传输日志
    - 快速使用web client
    - i18n
    - 通过 web client 分享给游客
    - server控制(一些官方的简单的指令 [wiki](https://github.com/lejianwen/rustdesk-api/wiki/Rustdesk-Command))
- Web Client
    - 自动获取API server
    - 自动获取ID服务器和KEY
    - 自动获取地址簿
    - 游客通过临时分享链接直接远程到设备
    - 支持自定义WS Host(用于网页客服端连接，参考[使用lucky开启HTTPS反向代理和webclient2连接](https://github.com/lejianwen/rustdesk-api/discussions/81))

