$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$exe = Join-Path $root 'cli-proxy-api.exe'
$config = Join-Path $root 'config.yaml'
$pidFile = Join-Path $root 'server.pid'
$outLog = Join-Path $root 'logs\server.out.log'
$errLog = Join-Path $root 'logs\server.err.log'

if (-not (Test-Path -LiteralPath $exe)) { throw "Missing program: $exe" }
if (-not (Test-Path -LiteralPath $config)) { throw "Missing config: $config" }
if (Test-Path -LiteralPath $pidFile) {
    $oldPid = [int](Get-Content -Raw -LiteralPath $pidFile)
    $oldProcess = Get-Process -Id $oldPid -ErrorAction SilentlyContinue
    if ($oldProcess -and $oldProcess.Path -eq $exe) {
        Write-Output "Already running (PID $oldPid)."
        return
    }
}

$process = Start-Process -FilePath $exe -ArgumentList @('-config', ('"' + $config + '"')) -WorkingDirectory $root -WindowStyle Hidden -RedirectStandardOutput $outLog -RedirectStandardError $errLog -PassThru
Set-Content -LiteralPath $pidFile -Value $process.Id -NoNewline
Start-Sleep -Seconds 2
if (-not (Get-Process -Id $process.Id -ErrorAction SilentlyContinue)) {
    throw "Server exited. See $errLog"
}
Write-Output "Running on http://127.0.0.1:8317 (PID $($process.Id))."
