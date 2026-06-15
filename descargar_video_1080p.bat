@echo off
setlocal enabledelayedexpansion

echo Descarga de video en 1080p con yt-dlp
echo.
set /p valorUrl=Introduce la URL de YouTube: 

if "%valorUrl%"=="" (
    echo.
    echo No se ha introducido ninguna URL. Saliendo...
    pause
    exit /b 1
)

yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 -o "%%(title)s - %%(id)s.%%(ext)s" "%valorUrl%"

echo.
echo Descarga finalizada.
pause