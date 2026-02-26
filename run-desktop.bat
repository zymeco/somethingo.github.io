@echo off
cd /d %~dp0

where npm >nul 2>nul
if %errorlevel% neq 0 (
  echo [ERROR] npm not found. Please install Node.js LTS first.
  pause
  exit /b 1
)

echo [1/2] Installing dependencies...
call npm install
if %errorlevel% neq 0 (
  echo [ERROR] npm install failed.
  pause
  exit /b 1
)

echo [2/2] Launching desktop app...
call npm run desktop
