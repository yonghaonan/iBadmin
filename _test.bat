@echo off
REM iBadmin 测试脚本 (Windows)
REM 用法: 双击或命令行执行 _test.bat
REM 依赖: hvigorw (HarmonyOS DevEco Studio 内置)
REM 输出: 末尾需含 "Test Suites: 4 passed, Test Cases: 43 passed, 0 failed"

setlocal

echo ========================================
echo  iBadmin 测试套件 (4 suites / 43 cases)
echo ========================================
echo.

cd /d "%~dp0"

REM 调用 hvigorw 跑 entry 模块的 ohosTest 任务
call hvigorw --mode module -p module=entry@ohosTest ohosTest

set EXIT_CODE=%ERRORLEVEL%

echo.
if %EXIT_CODE% EQU 0 (
  echo ========================================
  echo  测试通过 ✓
  echo ========================================
) else (
  echo ========================================
  echo  测试失败 ✗ (ExitCode: %EXIT_CODE%)
  echo ========================================
)

endlocal & exit /b %EXIT_CODE%
