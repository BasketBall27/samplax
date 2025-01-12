:: Contributors 2024-2025 Anonim "Socket"
@echo off
for /f "delims=" %%i in ('winget -v') do set version=%%i
title winget %version%
winget install --id=Microsoft.VCRedist.2015+.x86  -e
pause
