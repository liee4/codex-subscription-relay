$ErrorActionPreference = 'Stop'
$tailscale = 'C:\Program Files\Tailscale\tailscale.exe'
if (-not (Test-Path -LiteralPath $tailscale)) { throw 'Tailscale is not installed.' }
$principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $argumentLine = '-NoProfile -ExecutionPolicy Bypass -NoExit -File "' + $PSCommandPath + '"'
    Start-Process -FilePath 'powershell.exe' -ArgumentList $argumentLine -Verb RunAs
    return
}
$logFile = Join-Path $PSScriptRoot 'logs\funnel-setup.log'
Start-Transcript -LiteralPath $logFile -Append | Out-Null
try {
    & $tailscale status
    if ($LASTEXITCODE -ne 0) { throw 'Sign in to Tailscale first.' }
    & $tailscale funnel --bg 8317
    if ($LASTEXITCODE -ne 0) { throw "Funnel setup failed with exit code $LASTEXITCODE" }
    & $tailscale funnel status
} finally {
    Stop-Transcript | Out-Null
}
