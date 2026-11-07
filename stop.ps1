$ErrorActionPreference = 'Stop'
$exe = Join-Path $PSScriptRoot 'cli-proxy-api.exe'
$pidFile = Join-Path $PSScriptRoot 'server.pid'
if (-not (Test-Path -LiteralPath $pidFile)) { Write-Output 'No saved process ID.'; return }
$serverPid = [int](Get-Content -Raw -LiteralPath $pidFile)
$process = Get-Process -Id $serverPid -ErrorAction SilentlyContinue
if ($process) {
    if ($process.Path -ne $exe) { throw 'Saved process ID belongs to another program.' }
    Stop-Process -Id $serverPid
}
Remove-Item -LiteralPath $pidFile
Write-Output 'Stopped.'
