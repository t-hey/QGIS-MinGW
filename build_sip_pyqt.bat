echo off
REM In the root dir we will extract all the source and build the dependencies 
set ROOT_DIR=c:\cpp\dev
set LIBSEXTERNAL_DIR=%ROOT_DIR%\LibsExternal_
set MINGW_MAKETOOL=mingw32-make
REM Build SIP
set LIBNAME_DIR=sip
set LIB_VERSION=4.16.7
set LIBNAMEVERSION_DIR=%LIBNAME_DIR%-%LIB_VERSION%
set SOURCE_EXTRACT_DIR=%LIBSEXTERNAL_DIR%\%LIBNAME_DIR%

REM cd to extracted directory
cd %SOURCE_EXTRACT_DIR%\%LIBNAMEVERSION_DIR%
set PATH=%PATH%;C:\Qt\Qt5.4.1\5.4\mingw491_32\bin;C:\Qt\Qt5.4.1\Tools\mingw491_32\opt
REM python.exe configure.py LIBDIR+=c:\Qt\Qt5.4.1\Tools\mingw491_32\opt\libs --platform win32-g++
REM mingw32-make
REM mingw32-make install
pause

echo on
REM Build PyQt
set LIBNAME_DIR=PyQt
set LIB_VERSION=5.4.1
set LIBNAMEVERSION_DIR=%LIBNAME_DIR%-%LIB_VERSION%
set SOURCE_EXTRACT_DIR=%LIBSEXTERNAL_DIR%\%LIBNAME_DIR%

REM cd to extracted directory
cd %SOURCE_EXTRACT_DIR%\%LIBNAME_DIR%-gpl-%LIB_VERSION%
chdir
python.exe configure.py --confirm-license LIBDIR+=c:\Qt\Qt5.4.1\Tools\mingw491_32\opt\bin --spec win32-g++
mingw32-make
mingw32-make install
pause
REM exit