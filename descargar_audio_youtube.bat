@echo off
setlocal enabledelayedexpansion

echo Descarga de audio con yt-dlp
echo.
set /p valorUrl=Introduce la URL de YouTube: 

if "%valorUrl%"=="" (
    echo.
    echo No se ha introducido ninguna URL. Saliendo...
    pause
    exit /b 1
)

yt-dlp -f bestaudio -x --audio-format mp3 --audio-quality 192K -o "%%(artist)s - %%(title)s.%%(ext)s" "%valorUrl%"

echo.
echo Descarga finalizada.
pause