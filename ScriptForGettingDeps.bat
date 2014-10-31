@ECHO OFF
set LIBSDEP_DIR=\cpp\dev\LibsDep_
set DEST_DRIVE=c
set DEST_DIR=QgisDeps
set DEST_DIR_BAT=c:\cpp\dev
REM Command Script for the Include Bat file
dir /a:d /s /b %LIBSDEP_DIR% | grep -w include | sed "s/^/xcopy \/Y /" | sed "s/\(include[\\\\\a-z_]*\)/\1 %DEST_DRIVE%\:\\\\%DEST_DIR%\\\\\1\\\\*/" > %DEST_DIR_BAT%\copy_include.bat
REM Command Script for the bin bat file
dir /a:d /s /b %LIBSDEP_DIR% | grep -w bin | sed "s/^/xcopy \/Y /" | sed "s/\(bin[\\\\\a-z_]*\)/\1\\\\*.dll %DEST_DRIVE%\:\\\\%DEST_DIR%\\\\\1\\\\*/" > %DEST_DIR_BAT%\copy_bin.bat
REM Command Script for the lib bat file
dir /a:d /s /b %LIBSDEP_DIR% | grep -w lib | egrep -v "pkgconfig|gdalplugins|cmake|include" | sed "s/^/xcopy \/Y /" | sed "s/$/ %DEST_DRIVE%\:\\\\%DEST_DIR%\\\\lib\\\\*/" > %DEST_DIR_BAT%\copy_libs.bat

REM Running the bat files.
@ECHO ON
call %DEST_DIR_BAT%\copy_include.bat
call %DEST_DIR_BAT%\copy_bin.bat
call %DEST_DIR_BAT%\copy_libs.bat