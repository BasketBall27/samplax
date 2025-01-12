@echo off
for /f "delims=" %%i in ('winget -v') do set version=%%i
title winget %version%
winget install -e --id Git.Git
pause
