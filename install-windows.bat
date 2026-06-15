@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-windows-ui.ps1"
if errorlevel 1 (
  echo.
  echo Installation failed. Please keep this window open and send the error message to the publisher.
  pause
)
