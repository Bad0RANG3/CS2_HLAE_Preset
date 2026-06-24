@echo off
chcp 65001 >nul
setlocal

set "FFMPEG=C:\Program Files (x86)\HLAE FFMPEG\ffmpeg\bin\ffmpeg.exe"
set "INPUT_MP4=%~dp0raw.mp4"
set "INPUT_WAV=%~dp0audio.wav"
set "OUTPUT=%~dp0output.mp4"

echo ============================================
echo   合并 raw.mp4 + audio.wav -> output.mp4
echo ============================================

if not exist "%INPUT_MP4%" (
    echo [错误] 找不到 %INPUT_MP4%
    pause
    exit /b 1
)

if not exist "%INPUT_WAV%" (
    echo [错误] 找不到 %INPUT_WAV%
    pause
    exit /b 1
)

if not exist "%FFMPEG%" (
    echo [错误] 找不到 ffmpeg: %FFMPEG%
    pause
    exit /b 1
)

echo  视频: %INPUT_MP4%
echo  音频: %INPUT_WAV%
echo  输出: %OUTPUT%
echo.
echo  正在合并...

"%FFMPEG%" -i "%INPUT_MP4%" -i "%INPUT_WAV%" -c:v copy -c:a aac -b:a 192k -shortest "%OUTPUT%"

if %ERRORLEVEL% equ 0 (
    echo.
    echo [完成] 输出文件: %OUTPUT%
) else (
    echo.
    echo [失败] ffmpeg 执行出错!
)

pause
endlocal
