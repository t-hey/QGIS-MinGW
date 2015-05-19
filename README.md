## QGIS-MinGW
This is information on how to build QGIS with the MinGW toolchain.<br>
This repo contains a shell script to be used with MinGW-MSYS.

### Build Environment
- MinGW<br>
I used MinGW with posix threading and dwarf exception handling, for a explanation on dwarf see     http://stackoverflow.com/questions/15670169/what-is-difference-between-sjlj-vs-dwarf-vs-seh <br>
Get this version of MinGW here http://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/4.9.1/threads-posix/dwarf/i686-4.9.1-release-posix-dwarf-rt_v3-rev2.7z/download <br>

- MSYS<br>
Install MSYS with the mingw-get-setup.exe from this page http://www.mingw.org/wiki/getting_started and follow the instructions on how to use the MinGW you downloaded.<br>
- CMake.<br>
Download the lastest CMake and install.

**NOTE:** If you have build against the above MinGW you need the Qt version that you have on your machine, also build against the above version of MinGW, otherwise you will have dependencies build with a defferent version that Qt use to build against, and that can be problematic.<br>
If you already have Qt installed with MinGW, just get MSYS to use the MinGW that Qt use.<br>

### Usage
- Open MSYS and run build_gis_deps.sh script from where you have saved it on your machine.<br>
- Add the &lt;MSYS install dir&gt;\msys\1.0\local\bin,<br> &lt;MSYS install dir&gt;\msys\1.0\local\include and <br> &lt;MSYS install dir&gt;\msys\1.0\local\lib folders to you path.
- Clone/Fork the QGIS git repo https://github.com/t-hey/QGIS.git 
- Create a out of source build directory 
- cd to &lt;out of source build directory&gt;
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
