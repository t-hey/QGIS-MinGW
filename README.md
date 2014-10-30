QGisDeps-MinGW32
================

Information on how to build QGis dependencies with MinGW-MSYS. 

This repo contains a shell script to be used with MinGW-MSYS.
I used a MinGW with posix threading and dwarf pointers, for a explanation on dwarf see http://stackoverflow.com/questions/15670169/what-is-difference-between-sjlj-vs-dwarf-vs-seh

Get this version of MinGW here ttp://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/4.9.1/threads-posix/dwarf/i686-4.9.1-release-posix-dwarf-rt_v3-rev2.7z/download

Install MSYS with the mingw-get-setup.exe from this page http://www.mingw.org/wiki/getting_started and follow the instructions on how to use the MinGW you downloaded above.
Open MSYS and run build_gis_deps.sh from where you have it on your system.

NOTE: If you have build against the above MinGW you need the Qt version that you have on your machine, also build against the above version of MinGW, otherwise you will have dependencies build with a defferent version that Qt use to build against, and that will cause trouble. 
If you already have Qt installed with MinGW, just get MSYS to use the MinGW that Qt use. Then run the script to build the QGis dependencies.

All the dependencies have a build flag in the script that can be set, so that only one or more dependencies can be build. All of them can also be build at once if so desired and will take some time.

The script builds the following dependencies.
* Geos 
* FeeXL
* Proj4
* GDAL - with default settings
* SQLite
* GSL
* Expat
* Postgres - Just download the binary files and extract for use later with Qgis
* Flex - Just download the binary files and extract for use later with Qgis
* Bison - Just download the binary files and extract for use later with Qgis
* LibXML2
* Iconv
* Spatialite
* SpatialIndex
* Qwt
* QwtPolar

Hope this helps.
