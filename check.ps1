$ErrorActionPreference = 'Stop'
$key = (Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'api-key.txt')).Trim()
$headers = @{ Authorization = "Bearer $key" }
Invoke-RestMethod -Uri 'http://127.0.0.1:8317/v1/models' -Headers $headers | ConvertTo-Json -Depth 8
