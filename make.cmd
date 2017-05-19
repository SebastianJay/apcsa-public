@echo off & setlocal enabledelayedexpansion
@REM ===============================================================================================
@REM    AP CS A Curriculum Build Tool
@REM
@REM    This is just a simple script to perform automated tasks for the AP CS A curriculum project.
@REM    This script must be run from the root of the AP CS A curriculum project, in a command prompt
@REM    window.
@REM
@REM    Run `make help` for instructions.
@REM ===============================================================================================

if "%1" equ "" (
    call :help
    exit /b 0
)

path tools;%path%

:processTargets
    set target=%1
    if /i "%target%" equ "all" (
        call :pdfs
    ) else if /i "%target%" equ "clean" (
        call :clean
    ) else if /i "%target%" equ "fresh" (
        call :clean
        call :pdfs
    ) else if /i "%target%" equ "pdfs" (
        call :pdfs
    ) else if /i "%target%" equ "help" (
        call :help
    ) else if /i "%target%" equ "/?" (
        call :help
    ) else if /i "%target%" equ "-?" (
        call :help
    ) else (
        @echo ERROR: Unrecognized target ^(%target%^). 1>&2
        call :help
    )

    shift
    if "%1" neq "" goto :processTargets

:endLoop
exit /b 0


@REM _______________________________________________________________________________________________
:clean
    rmdir 2>nul /s /q out
    goto :eof


@REM _______________________________________________________________________________________________
:pdfs
    mkdir 2>nul out\PDF
    for /f "delims=" %%f in (docx.manifest) do (
        echo "%%f"
        set filename=%%~nxf
        echo ftimecomp --handle-missing "%%f.docx" "out\PDF\!filename!.pdf"
             ftimecomp --handle-missing "%%f.docx" "out\PDF\!filename!.pdf"
        if !errorlevel! equ 1 (
            @REM // Unfortunately, docto.exe can't properly handle files if they're stored on
            @REM // the A: drive. To work around this, first copy the .docx file to the %TEMP%
            @REM // directory, which should be on the system drive, which is typically C:.

            echo copy ^>nul "%%f.docx" "%temp%\x.docx"
                 copy  >nul "%%f.docx" "%temp%\x.docx"

            echo docto.exe -T wdFormatPDF -F "%temp%\x.docx" -O "x.pdf"
                 docto.exe -T wdFormatPDF -F "%temp%\x.docx" -O "x.pdf"

            echo move ^>nul x.pdf "out\PDF\!filename!.pdf"
                 move  >nul x.pdf "out\PDF\!filename!.pdf"

            echo.
        )
    )
    goto :eof


@REM _______________________________________________________________________________________________
:help
    @echo.
    @echo.This script runs the various tasks of the AP CS A curriculum project. Supply any
    @echo.combination of the following keywords:
    @echo.
    @echo.    clean - delete all generated files
    @echo.
    @echo.    pdfs  - Build all PDF files from Word docx sources, using `docx.manifest`.
    @echo.            Output PDF files are saved to the out\PDF directory.
    @echo.
    @echo.    all   = pdfs
    @echo.    fresh = clean + pdfs
    @echo.
    goto :eof
