@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0enable-funnel.ps1"
if errorlevel 1 pause
