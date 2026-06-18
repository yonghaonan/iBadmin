@echo off
REM iBadmin 构建脚本 (Windows)
REM 用法: 双击或命令行执行 _build.bat
REM 依赖: hvigorw (HarmonyOS DevEco Studio 内置)

setlocal

echo ========================================
echo  iBadmin 构建 entry HAP
echo ========================================
echo.

cd /d "%~dp0"

REM 调用 hvigorw 编译 entry 模块
call hvigorw assembleHap --mode module -p module=entry@default -p buildMode=debug

set EXIT_CODE=%ERRORLEVEL%

echo.
if %EXIT_CODE% EQU 0 (
  echo ========================================
  echo  构建成功 ✓
  echo  产物: entry/build/default/outputs/default/entry-default-unsigned.hap
  echo ========================================
) else (
  echo ========================================
  echo  构建失败 ✗ (ExitCode: %EXIT_CODE%)
  echo ========================================
)

endlocal & exit /b %EXIT_CODE%
