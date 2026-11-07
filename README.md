# Windows 自用 Codex 中转配置

本仓库提供 Windows 配置脚本，使用 [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) 在本机运行兼容 OpenAI 接口的服务；需要从其他设备访问时，可选用 [Tailscale Funnel](https://tailscale.com/docs/features/tailscale-funnel)。项目来源和许可说明见 [第三方项目说明](THIRD_PARTY_NOTICES.md)。

**仓库不包含可执行程序、Codex 登录凭证、API 密钥或个人公网地址。** 每位使用者都需要在自己的电脑上生成密钥并登录自己的账户。本项目并非 OpenAI 官方 API，能使用的模型和额度取决于账户本身。

## 在 Windows 上安装

准备 Node.js 和 PowerShell，在本目录依次运行：

```powershell
node .\download.mjs
Expand-Archive .\CLIProxyAPI_8.0.59_windows_amd64.zip -DestinationPath . -Force
node .\init-config.mjs
.\login.ps1
.\start.ps1
.\check.ps1
```

`download.mjs` 下载指定版本的 CLIProxyAPI，并校验压缩包的 SHA-256。`init-config.mjs` 生成随机 API 密钥和仅监听本机的配置。运行 `login.ps1` 后，按浏览器提示完成 Codex 授权。

在支持自定义 OpenAI 兼容接口的程序中填写：

```text
接口地址（Base URL）：http://127.0.0.1:8317/v1
API 密钥：本机 api-key.txt 文件的内容
模型名称：运行 .\check.ps1 后，从返回的模型中选择
```

运行 `.\stop.ps1` 可停止本机服务。请妥善保管 `config.yaml`、`api-key.txt`、`auths/` 和 `logs/`。`.gitignore` 已排除这些文件和目录，发布代码前仍应检查每次提交。

## 从其他设备访问

在运行服务的 Windows 电脑上安装并登录 Tailscale。先到 Tailscale 管理页面为自己的网络启用 HTTPS 和 Funnel，再双击 `开启公网入口.cmd`，同意 Windows 管理员提示。Tailscale 会显示类似 `https://YOUR-DEVICE.YOUR-TAILNET.ts.net/` 的地址。将末尾加上 `/v1` 作为其他设备的接口地址，并填写同一个私有 API 密钥。电脑、本机服务和 Tailscale 都需要保持运行。

Funnel 地址可被公网访问。别人仅知道网址时可以连接到接口，但没有有效 API 密钥的模型请求会返回 HTTP 401，无法调用模型。请勿分享密钥；若密钥泄露，请同时修改 `config.yaml` 和 `api-key.txt`，然后重启服务。双击 `关闭公网入口.cmd` 可关闭公网访问。

这些脚本不会生成 OpenAI 官方 API Key。具体客户端是否支持所需接口和参数，需要在该客户端中验证。
