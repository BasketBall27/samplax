:: Contributors 2024-2025 Anonim "Socket"
@echo off
for /f "delims=" %%i in ('winget -v') do set version=%%i
title winget %version%
winget install -e --id Oracle.JavaRuntimeEnvironment
pause
