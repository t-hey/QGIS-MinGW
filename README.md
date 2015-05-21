## QGIS-MinGW
This is information on how to build QGIS with the MinGW toolchain.<br>
This repo contains a shell script to be used with MinGW-MSYS.

### Build Environment
- MinGW<br>
I used MinGW with posix threading and dwarf exception handling, for a explanation on dwarf see     http://stackoverflow.com/questions/15670169/what-is-difference-between-sjlj-vs-dwarf-vs-seh <br>
<br>
Get latest version of MinGW here http://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/4.9.1/threads-posix/dwarf <br>

- MSYS<br>
Install MSYS with the mingw-get-setup.exe from this page http://www.mingw.org/wiki/getting_started and follow the instructions on how to use the MinGW you downloaded.<br>
- CMake.<br>
Download the lastest CMake and install, and add it to the path.<br>
- 7Zip<br>
Download 7Zip and install, and add it to the path

**NOTE:** If you have build against the above MinGW you need the Qt version that you have on your machine, also build against the above version of MinGW, otherwise you will have dependencies build with a defferent version that Qt use to build against, and that can be problematic.<br>
If you already have Qt installed with MinGW, just get MSYS to use the MinGW that Qt use.<br>
Qt 5.4.1 for Windows already comes with correct version of MinGW, all you need then is to get MSYS and know where Qt installed the MinGW. In my installation it is in C:\Qt\Qt5.4.1\Tools\mingw491_32<br>
Further more this MinGW version comes with a python build aswell, so you can use that to build SIP, PyQt and then the python bindings for QGis.

### Usage
- Clone the QGis-MinGW repo to your machine.
- Open MSYS and run build_gis_deps.sh script from the cloned repo.<br>
- Add the &lt;<i>MSYS install dir</i>&gt;\msys\1.0\local\bin,<br> 
&lt;<i>MSYS install dir</i>&gt;\msys\1.0\local\include and <br> 
&lt;<i>MSYS install dir</i>&gt;\msys\1.0\local\lib folders to you path.
- Clone/Fork the QGIS git repo https://github.com/qgis/QGIS 
- Create a out of source build directory e.g. c:\cpp\build-qgis-2.8-5.4.1-debug
- cd to &lt;<i>out of source build directory</i>&gt;
- Issue the commands in the qgis_cmake_command.txt file.

All the dependencies have a build flag in the script that can be set (true or false), so that only one or more dependencies can be build. All of them can also be build at once if so desired and will take some time.

### Script Details
The script builds the following dependencies.
- ZLib
- Geos 
- FeeXL
- Proj4
- GDAL - with default settings
- SQLite
- GSL
- Expat
- Postgres - Just download the binary files and extract for use later with Qgis
- Flex - Just download the binary files and extract for use later with Qgis
- Bison - Just download the binary files and extract for use later with Qgis
- LibXML2
- Iconv
- Spatialite
- SpatialIndex
- Qwt
- QwtPolar

Hope this helps.
