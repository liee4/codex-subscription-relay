# Windows Codex relay setup

Personal Windows setup scripts for a local OpenAI-compatible endpoint using [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI). Optional access from other devices uses [Tailscale Funnel](https://tailscale.com/docs/features/tailscale-funnel). See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for project attribution and licensing.

**The repository contains no executable, Codex login credential, API key, personal Tailscale address, or running service.** Each user generates a private key and authorizes their own account locally. This is an unofficial integration, and available models and usage remain subject to the account's limits.

## Set up on Windows

Install Node.js and PowerShell, then run these commands in this directory:

```powershell
node .\download.mjs
Expand-Archive .\CLIProxyAPI_8.0.59_windows_amd64.zip -DestinationPath . -Force
node .\init-config.mjs
.\login.ps1
.\start.ps1
.\check.ps1
```

`download.mjs` pins CLIProxyAPI `v8.0.59` and verifies the downloaded archive's SHA-256. `init-config.mjs` generates a random API key and local-only configuration. Complete the Codex authorization in your browser when `login.ps1` prompts you.

Enter these values in a client that supports a custom OpenAI-compatible endpoint:

```text
Base URL: http://127.0.0.1:8317/v1
API Key:  contents of your local api-key.txt
Model:    one of the models returned by .\check.ps1
```

Use `.\stop.ps1` to stop the local service. Keep `config.yaml`, `api-key.txt`, `auths/`, and `logs/` private. The included `.gitignore` excludes them, but check every commit before publishing.

## Access from another device

Install and sign in to Tailscale on the Windows host. After enabling HTTPS and Funnel for your tailnet in the Tailscale admin console, double-click `开启公网入口.cmd` and approve the Windows administrator prompt. Tailscale prints a URL similar to `https://YOUR-DEVICE.YOUR-TAILNET.ts.net/`. Use that URL with `/v1` appended as the client's Base URL, plus the same private API key. The host PC, local service, and Tailscale must stay running.

Funnel makes the address reachable by anyone on the internet. Knowing the URL lets someone connect to the endpoint, but requests without a valid API key should receive HTTP 401 and cannot use the model API. Keep the key private; if it leaks, replace it in `config.yaml` and `api-key.txt`, then restart the service. To disable public access, double-click `关闭公网入口.cmd`.

This setup does not create an official OpenAI API key. Client support for specific endpoints or parameters must be checked with the client you use.
