$ErrorActionPreference = 'Stop'
$exe = Join-Path $PSScriptRoot 'cli-proxy-api.exe'
$config = Join-Path $PSScriptRoot 'config.yaml'
& $exe -config $config -codex-login
if ($LASTEXITCODE -ne 0) { throw "Codex login failed with exit code $LASTEXITCODE" }
