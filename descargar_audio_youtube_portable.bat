@echo off
setlocal
chcp 65001 >nul

rem Script portátil para descargar y convertir audio usando yt-dlp y ffmpeg
rem Coloca este .bat junto a ffmpeg.exe y yt-dlp-2026-06-09.exe (o yt-dlp.exe)

set "SCRIPT_DIR=%~dp0"
set "SRC_DIR=%SCRIPT_DIR%src\"

rem Buscar yt-dlp: primero en bin, luego en la carpeta del script
if exist "%SRC_DIR%yt-dlp-2026-06-09.exe" (
    set "YTDLP=%SRC_DIR%yt-dlp-2026-06-09.exe"
) else if exist "%SRC_DIR%yt-dlp.exe" (
    set "YTDLP=%SRC_DIR%yt-dlp.exe"
) else if exist "%SCRIPT_DIR%yt-dlp-2026-06-09.exe" (
    set "YTDLP=%SCRIPT_DIR%yt-dlp-2026-06-09.exe"
) else if exist "%SCRIPT_DIR%yt-dlp.exe" (
    set "YTDLP=%SCRIPT_DIR%yt-dlp.exe"
) else (
    echo ❌ No se encontro yt-dlp en "%SRC_DIR%" ni en "%SCRIPT_DIR%".
    echo Copia "yt-dlp-*.exe" o "yt-dlp.exe" en la carpeta src o junto a este .bat.
    pause
    exit /b 1
)

rem Comprobar ffmpeg: primero en src, luego en la carpeta del script
if exist "%SRC_DIR%ffmpeg.exe" (
    set "FFMPEG_EXE=%SRC_DIR%ffmpeg.exe"
) else if exist "%SCRIPT_DIR%ffmpeg.exe" (
    set "FFMPEG_EXE=%SCRIPT_DIR%ffmpeg.exe"
) else (
    echo ❌ No se encontro ffmpeg.exe en "%SRC_DIR%" ni en "%SCRIPT_DIR%".
    echo Copia "ffmpeg.exe" en la carpeta src o junto a este .bat.
    pause
    exit /b 1
)

rem Obtener URL: si no se pasa por argumento, pedir al usuario
rem Iniciar control de procesamiento de argumentos y bucle principal
set "ARG_PROCESSED=0"
set "OUT_NAME="

:LOOP
if "%ARG_PROCESSED%"=="0" (
    if "%~1"=="" (
        set /p "URL=🔗 Introduce la URL del video (deja vacio para salir): "
    ) else (
        set "URL=%~1"
        if not "%~2"=="" set "OUT_NAME=%~2"
        set "ARG_PROCESSED=1"
    )
) else (
    set "OUT_NAME="
    set /p "URL=🔗 Introduce la URL del video (deja vacio para salir): "
)

if "%URL%"=="" (
    echo 🚫 No se proporciono ninguna URL. Saliendo.
    goto :END
)

rem Preparar ruta de ffmpeg (carpeta que contiene ffmpeg.exe) evitando backslash final problemático
set "FFMPEG_LOC=%~dp0src."
if exist "%SCRIPT_DIR%ffmpeg.exe" (
    set "FFMPEG_LOC=%SCRIPT_DIR%."
)

rem Ejecutar yt-dlp usando ffmpeg local. Los porcentajes para la plantilla
rem de salida deben escaparse con %% en un .bat para que lleguen literales
if "%OUT_NAME%"=="" (
    "%YTDLP%" --ffmpeg-location "%FFMPEG_LOC%" -x --audio-format mp3 --audio-quality 0 -o "%SCRIPT_DIR%%%(title)s.%%(ext)s" "%URL%"
) else (
    "%YTDLP%" --ffmpeg-location "%FFMPEG_LOC%" -x --audio-format mp3 --audio-quality 0 -o "%SCRIPT_DIR%%OUT_NAME%.%%(ext)s" "%URL%"
)

if errorlevel 1 (
    echo ❌ Ocurrio un error durante la descarga/convertir.
    goto :LOOP
)

echo ✅ Descarga y conversion completadas.
echo 📁 Archivo(s) guardados en "%SCRIPT_DIR%"
goto :LOOP

:END
endlocal
exit /b 0
