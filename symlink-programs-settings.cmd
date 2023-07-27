@echo off & setlocal enabledelayedexpansion
@REM setlocal enabledelayedexpansion
@REM %1 - path to source dir  (ProgramSettings)

set "_source=%1"
if "%_source%" equ "" goto :askSource
goto :checkSource
:askSource
set /p "_source=Enter path to directory with directories of symlink sources: " || goto :askSource
:checkSource
set "_source="%_source%""
if not exist %_source% (
  echo Directory not found. Try another..
  goto :askSource
)

pushd %_source%

for /f "delims=" %%i in ('dir /b %_source%') do (
  set "_dir="
  call :defineTarget %%~fi
  echo.
  for /f "delims=" %%j in ('dir /b %%i') do (
    set "_target="%%~fi\%%j""
    set "_link="!_dir!\%%j""
    echo mklink /j !_link! !_target!
    @REM todo for files not dirs?
  )
  echo.
)
popd

exit /b

:defineTarget
@REM %1 - source path
echo %1| findstr /i /e /c:"\APPDATA" >NUL
if %errorlevel% equ 0 (
  set _dir=%APPDATA%
  exit /b
)

echo %1| findstr /i /e /c:"\LOCALAPPDATA" >NUL
if %errorlevel% equ 0 (
  set _dir=%LOCALAPPDATA%
  exit /b
)

echo %1| findstr /i /e /c:"\LOCALAPPDATA-MICROSOFT" >NUL
if %errorlevel% equ 0 (
  set _dir=%LOCALAPPDATA%\MICROSOFT
  exit /b
)

echo %1| findstr /i /e /c:"\PROGRAMDATA" >NUL
if %errorlevel% equ 0 (
  set _dir=%PROGRAMDATA%
  exit /b
)

echo %1| findstr /i /e /c:"\USERPROFILE" >NUL
if %errorlevel% equ 0 (
  set _dir=%USERPROFILE%
  exit /b
)

echo %1| findstr /i /e /c:"\USERPROFILE-DOCUMENTS" >NUL
if %errorlevel% equ 0 (
  set _dir=%USERPROFILE%\DOCUMENTS
  exit /b
)
exit /b
