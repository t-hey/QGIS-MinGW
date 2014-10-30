#! /bin/bash

#In the root dir we will extract all the source and build the dependencies 
ROOT_DIR='/c/cpp/dev'
#Setup the downloads directory for downloading the Source 
DOWNLOAD_DIR=$ROOT_DIR/downloads
#In this dir all the build binaries and include files will be installed here
LIBSDEP_DIR='LibsDep_'
#In this dir all the source for the dependencies will extracted
LIBSEXTERNAL_DIR='LibsExternal_'
#This will show that we are building for win32
ARCH='win32'
#name of the too to be used for extracting downloaded zip files
ZIPTOOL='7z.exe x'
#Make tool for mingw
MINGW_MAKETOOL='mingw32-make'
#make tool for MSYS
MAKETOOL='make'
#CMake string for the type of makefiles to be generated
CMAKE_GENERATOR_NAME='MSYS Makefiles'
#Name for the CMake tool
CMAKE_TOOL='cmake -G'
#Build options for qmake
QMAKE_BUILD_OPTIONS='-makefile -spec win32-g++'
#Path to the qmake exe
QMAKE='c:/Qt/qt-5.3.2/bin/qmake'

#************* Flags for which dependencies to build, by default all is false **************
BUILD_ZLIB=false

BUILD_GEOS=false #Build with cmake, i get link errors when configure generate the makefiles
BUILD_FREEXL=false
BUILD_PROJ4=false
BUILD_GDAL=false
BUILD_SQLite=false
BUILD_GSL=false
BUILD_EXPAT=false
BUILD_POSTGRES=false
BUILD_FLEX=false
BUILD_BISON=false
BUILD_XML2=false
BUILD_ICONV=false
BUILD_SPATIALITE=false
BUILD_SPATIALINDEX=false #Build it with CMAKE the configure does not work
GET_QWT=false
BUILD_QWT=false
GET_QWTPOLAR=false
BUILD_QWTPOLAR=false

#************** Define colors *********************
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"

# Check if libdl.a is installed. 
# When building spatialite the configure script somehow pick up that libld is installed, 
# and add -ldl to the linklist of the examples in spatialite, 
# then the build process crash if it is not present
if [ ! -f "/lib/libdl.a" ]; then
 BUILD_LIB_DL=true 
else
 BUILD_LIB_DL=false    
fi 

#Check binary paths
if [[ $QMAKE == '' ]]; then
    echo "You have to set the path to the qmake.exe"
    exit
else
    if [ ! -f "$QMAKE" ]; then
     echo $QMAKE does not exist, fix the path to the qmake.exe 
     exit
    fi
fi

echo -e $GREEN Checking if $ROOT_DIR directory exist $NORMAL 
if [ ! -d "$ROOT_DIR" ]; then
  echo "creating $ROOT_DIR"
  mkdir -p $ROOT_DIR
fi

echo -e $GREEN Checking if $DOWNLOAD_DIR exist $NORMAL
if [ ! -d "$DOWNLOAD_DIR" ]; then
  echo "creating $DOWNLOAD_DIR folder"
  mkdir -p $DOWNLOAD_DIR
fi

echo -e $GREEN Checking if $ROOT_DIR/$LIBSDEP_DIR exist $NORMAL 
if [ ! -d "$ROOT_DIR/$LIBSDEP_DIR" ]; then
  echo "creating $ROOT_DIR/$LIBSDEP_DIR"
  mkdir -p $LIBSDEP_DIR
fi
echo -e $GREEN Checking if $ROOT_DIR/$LIBSEXTERNAL_DIR exist $NORMAL
if [ ! -d "$ROOT_DIR/$LIBSEXTERNAL_DIR" ]; then
  echo "creating $ROOT_DIR/$LIBSEXTERNAL_DIR"
  mkdir -p $LIBSEXTERNAL_DIR
fi


if $BUILD_ZLIB ; then
#========[Start with ZLIB]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR
    LIB_NAME_DIR='zlib'
    LIB_NAMEVERSION_DIR='zlib-1.2.8'
    SOURCE_ARCHIVE='zlib-1.2.8.tar.gz'
    SOURCE_URL='http://zlib.net/zlib-1.2.8.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/$LIB_NAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/$LIB_NAME_DIR/$LIB_NAMEVERSION_DIR/$ARCH

    # Getting and building ZLIB
    echo && echo -e $GREEN  Getting and building $LIB_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of ZLIB
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of ZLIB
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_NAMEVERSION_DIR
    #pwd
    echo -e $GREEN  Build LIB_NAMEVERSION_DIR $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    export BINARY_PATH=$BIN_INSTALL_DIR/bin 
    export INCLUDE_PATH=$BIN_INSTALL_DIR/include
    export LIBRARY_PATH=$BIN_INSTALL_DIR/lib 
    $MINGW_MAKETOOL -f win32/Makefile.gcc && $MINGW_MAKETOOL install -f win32/Makefile.gcc SHARED_MODE=1
    echo
#========[Finish with ZLIB]===================================
fi
LIB_GEOS_NAME_DIR='geos'
LIB_GEOS_NAMEVERSION_DIR='geos-3.4.2'
if $BUILD_GEOS ; then
#========[Start with GEOS]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='geos-3.4.2.tar.bz2'
    SOURCE_URL='http://download.osgeo.org/geos/geos-3.4.2.tar.bz2'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_GEOS_NAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_GEOS_NAME_DIR/$LIB_GEOS_NAMEVERSION_DIR/$ARCH

    # Getting and building GEOS
    echo && echo -e $GREEN  Getting and Building $LIB_GEOS_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of GEOS
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of GEOS
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -xjf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_GEOS_NAMEVERSION_DIR
    pwd
    echo -e $RED Fix the tools/CMakeLists.txt file to generate the geos.config file $NORMAL
    sed -i 's/UNIX/UNIX OR MINGW/g' tools/CMakeLists.txt

    echo -e $GREEN configure makefiles $NORMAL
    
    rm -rf build
    mkdir -p build
    cd build
    echo -e $YELLOW $CMAKE_TOOL "$CMAKE_GENERATOR_NAME" ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=$BIN_INSTALL_DIR -DHAVE_STD_ISNAN=1 -DGEOS_ENABLE_INLINE=NO  -DGEOS_ENABLE_TESTS=ON  $NORMAL
    $CMAKE_TOOL "$CMAKE_GENERATOR_NAME" ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=$BIN_INSTALL_DIR -DHAVE_STD_ISNAN=1 -DGEOS_ENABLE_INLINE=NO  -DGEOS_ENABLE_TESTS=ON 
    echo -e $GREEN  build binaries $NORMAL
    $MINGW_MAKETOOL
    $MINGW_MAKETOOL test
    $MINGW_MAKETOOL check
    $MINGW_MAKETOOL install

    echo
#========[Finish with GEOS]===================================
fi

LIB_FREEXL_NAME_DIR='freexl'
LIB_FREEXL_NAMEVERSION_DIR='freexl-1.0.0g'
if $BUILD_FREEXL ; then
#========[Start with FREEXL]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='freexl-1.0.0g.tar.gz'
    SOURCE_URL='http://www.gaia-gis.it/gaia-sins/freexl-1.0.0g.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_FREEXL_NAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_FREEXL_NAME_DIR/$LIB_FREEXL_NAMEVERSION_DIR/$ARCH

    # Getting and building FREEXL
    echo && echo -e $GREEN  Getting and building $LIB_FREEXL_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of FREEXL
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of FREEXL
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_FREEXL_NAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure  makefiles $NORMAL
    echo -e $YELLOW && ./configure --prefix=$BIN_INSTALL_DIR && echo -e $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    $MINGW_MAKETOOL && $MINGW_MAKETOOL install
    echo
#========[Finish with FREEXL]===================================
fi

LIB_PROJ4_NAME_DIR='proj4'
LIB_PROJ4_NAMEVERSION_DIR='proj-4.8.0'
if $BUILD_PROJ4 ; then
#========[Start with PROJ4]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='proj-4.8.0.tar.gz'
    SOURCE_URL='http://download.osgeo.org/proj/proj-4.8.0.tar.gz'
  
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_PROJ4_NAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_PROJ4_NAME_DIR/$LIB_PROJ4_NAMEVERSION_DIR/$ARCH

    # Getting and building PROJ4
    echo && echo -e $GREEN  Getting and building $LIB_PROJ4_NAMEVERSION_DIR $NORMAL
    pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of PROJ4
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of PROJ4
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL
    
    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_PROJ4_NAMEVERSION_DIR
    pwd
    echo -e $GREEN  configure makefiles $NORMAL
     echo -e $YELLOW && ./configure  --prefix=$BIN_INSTALL_DIR && echo -e $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
#========[Finish with PROJ4]===================================
fi

if $BUILD_GDAL ; then
    #========[Start with GDAL]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='gdal'
    LIBNAMEVERSION_DIR='gdal-1.11.1'
    SOURCE_ARCHIVE='gdal1111.zip'
    SOURCE_URL='http://download.osgeo.org/gdal/1.11.1/gdal1111.zip'
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIBNAME_DIR/$LIBNAMEVERSION_DIR/$ARCH

    # Getting and building GDAL
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of gdal
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of gdal
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    $ZIPTOOL $SOURCE_ARCHIVE -o$SOURCE_EXTRACT_DIR

    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure makefiles $NORMAL
    export CPPFLAGS="-I$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_GEOS_NAME_DIR/$LIB_GEOS_NAMEVERSION_DIR/win32/include -I$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_FREEXL_NAME_DIR/$LIB_FREEXL_NAMEVERSION_DIR/win32/include -I$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_PROJ4_NAME_DIR/$LIB_PROJ4_NAMEVERSION_DIR/win32/include"
    echo $CPPFLAGS
    export LDFLAGS="-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_PROJ4_NAME_DIR/$LIB_PROJ4_NAMEVERSION_DIR/win32/lib -L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_FREEXL_NAME_DIR/$LIB_FREEXL_NAMEVERSION_DIR/win32/lib -L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_GEOS_NAME_DIR/$LIB_GEOS_NAMEVERSION_DIR/win32/lib"
    echo $LDFLAGS

     echo -e $YELLOW && ./configure --with-geos=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_GEOS_NAME_DIR/$LIB_GEOS_NAMEVERSION_DIR/win32/bin/geos-config --prefix=$BIN_INSTALL_DIR &&  echo -e $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
#========[Finish with GDAL]===================================
fi

LIB_SQLLITE_NAME_DIR='sqlite'
LIB_SQLLITE_NAMEVERSION_DIR='sqlite-3.8.7'
if $BUILD_SQLite ; then
    #========[Start with SQLite]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='sqlite-autoconf-3080700.tar.gz'
    SOURCE_URL='http://www.sqlite.org/2014/sqlite-autoconf-3080700.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_SQLLITE_NAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_SQLLITE_NAME_DIR/$LIB_SQLLITE_NAMEVERSION_DIR/$ARCH

    # Getting and building SQLite
    echo && echo -e $GREEN  Getting and building $NORMAL $LIB_SQLLITE_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SQLite
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of SQLite
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/sqlite-autoconf-3080700
    #pwd
    echo -e $GREEN  configure makefiles $NORMAL
     echo -e $YELLOW && ./configure --prefix=$BIN_INSTALL_DIR &&  echo -e $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
#========[Finish with SQLite]===================================
fi

if $BUILD_GSL ; then
#========[Start with GSL]===================================
     #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='gsl'
    LIBNAMEVERSION_DIR='gsl-1.16'
    SOURCE_ARCHIVE='gsl-1.16.tar.gz'
    SOURCE_URL='ftp://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIBNAME_DIR/$LIBNAMEVERSION_DIR/$ARCH

    # Getting and building GSL
    echo && echo -e $GREEN  Getting and building $NORMAL $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of GSL
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of GSL
    rm -rf $BIN_INSTALL_DIR
    
    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure GSL makefiles $NORMAL
     echo -e $YELLOW && ./configure --prefix=$BIN_INSTALL_DIR &&  echo -e $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
#========[Finish with GSL]===================================
fi

if $BUILD_EXPAT ; then
#========[Start with Expat]===================================
     #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='expat'
    LIBNAMEVERSION_DIR='expat-2.1.0'
    SOURCE_ARCHIVE='expat-2.1.0.tar.gz'
    SOURCE_URL='http://sourceforge.net/projects/expat/files/expat/2.1.0/expat-2.1.0.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIBNAME_DIR/$LIBNAMEVERSION_DIR/$ARCH

    # Getting and building Expat
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of Expat
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of Expat
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure Expat makefiles $NORMAL
     echo -e $YELLOW && ./configure --prefix=$BIN_INSTALL_DIR &&  echo -e $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    $MAKETOOL && $MAKETOOL install
#========[Finish with Expat]===================================
fi

if $BUILD_POSTGRES ; then
#========[Start with Postgres]===================================
    #We are just extracting the postgres binaries not building postres
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='postgres'
    LIBNAMEVERSION_DIR='postgresql-9.3.5-1'
    BINARY_ARCHIVE='postgresql-9.3.5-1-windows-binaries.zip'
    SOURCE_URL='http://get.enterprisedb.com/postgresql/postgresql-9.3.5-1-windows-binaries.zip'

    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/$LIBNAME_DIR/$LIBNAMEVERSION_DIR/$ARCH

    echo && echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous build binaries  of Postgres
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the install directory
    mkdir -p $BIN_INSTALL_DIR
    pwd
    echo -e $GREEN  Extract the binaries for $LIBNAMEVERSION_DIR $NORMAL
    #Extract the zip file
    echo $ZIPTOOL $BINARY_ARCHIVE -o$BIN_INSTALL_DIR
    $ZIPTOOL $BINARY_ARCHIVE -o$BIN_INSTALL_DIR
    echo
#========[Finish with Postgres]===================================
fi

if $BUILD_FLEX ; then
#========[Start with FLEX]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='flex'
    LIBNAMEVERSION_DIR='flex-2.5.4a'
    BINARY_ARCHIVE='flex-2.5.4a-1-bin.zip'
    SOURCE_URL='http://downloads.sourceforge.net/project/gnuwin32/flex/2.5.4a-1/flex-2.5.4a-1-bin.zip'

    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/$LIBNAME_DIR/$LIBNAMEVERSION_DIR/$ARCH

    echo && echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous build binaries  of FLEX
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the install directory
    mkdir -p $BIN_INSTALL_DIR
    #pwd
    #Extract the zip file
    echo -e $GREEN  Extract the binaries for $LIBNAMEVERSION_DIR $NORMAL
    $ZIPTOOL $BINARY_ARCHIVE -o$BIN_INSTALL_DIR
    echo
#========[Finish with FLEX]===================================
fi

if $BUILD_BISON ; then
#========[Start with BISON]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='bison'
    LIBNAMEVERSION_DIR='bison-2.4.1'
    BINARY_ARCHIVE='bison-2.4.1-bin.zip'
    SOURCE_URL='http://downloads.sourceforge.net/project/gnuwin32/bison/2.4.1/bison-2.4.1-bin.zip'

    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/$LIBNAME_DIR/$LIBNAMEVERSION_DIR/$ARCH

    echo && echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous build binaries  of BISON
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the install directory
    mkdir -p $BIN_INSTALL_DIR
    #pwd
    #Extract the zip file
    echo -e $GREEN  Extract the binaries for $LIBNAMEVERSION_DIR $NORMAL
    $ZIPTOOL $BINARY_ARCHIVE -o$BIN_INSTALL_DIR
    echo
#========[Finish with BISON]===================================
fi

LIB_XML_NAME_DIR='libxml2'
LIB_XML_NAMEVERSION_DIR='libxml2-2.9.2'
if $BUILD_XML2 ; then
#========[Start with libXml2]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='libxml2-2.9.2.tar.gz'
    SOURCE_URL='http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_XML_NAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_XML_NAME_DIR/$LIB_XML_NAMEVERSION_DIR/$ARCH

    # Getting and building Expat
    echo && echo -e $GREEN  Getting and building $LIB_XML_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of Expat
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of Expat
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_XML_NAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure Expat makefiles $NORMAL
     echo -e $YELLOW && ./configure --without-python --prefix=$BIN_INSTALL_DIR &&  echo -e $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    $MAKETOOL && $MAKETOOL install
#========[Finish with libXml2]===================================
fi

LIBNAME_ICONV_DIR='iconv'
LIBNAMEVERSION_ICONV_DIR='libiconv-1.14'
if $BUILD_ICONV ; then
#========[Start with ICONV]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='libiconv-1.14.tar.gz'
    SOURCE_URL='http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_ICONV_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIBNAME_ICONV_DIR/$LIBNAMEVERSION_ICONV_DIR/$ARCH

    # Getting and building ICONV
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_ICONV_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of ICONV
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of ICONV
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_ICONV_DIR
    #pwd
    echo -e $GREEN  configure ICONV makefiles $NORMAL
    echo -e $YELLOW && ./configure --prefix=$BIN_INSTALL_DIR &&  echo -e $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
#========[Finish with ICONV]===================================
fi

if $BUILD_LIB_DL ; then
#========[Start with LIB_DL]===================================
    #Change to downloads folder
    echo && echo -e $YELLOW We need to build the libld.dll for spatialite $NORMAL
    echo -e $YELLOW The libld.dll does not ship with the MSys so we have to get the source and build it $NORMAL
    echo -e $YELLOW for more information see http://stackoverflow.com/questions/12455160/using-libdl-so-in-mingw $NORMAL
    
    cd $DOWNLOAD_DIR
    
    LIBNAME_DLFCN_DIR='dlfcn-win32'
    LIBNAMEVERSION_DLFCN_DIR='dlfcn-win32-master'
    SOURCE_ARCHIVE='master'
    SOURCE_URL='https://github.com/dlfcn-win32/dlfcn-win32/archive/master.zip'
    
    mkdir -p $LIBNAME_DLFCN_DIR
    cd $LIBNAME_DLFCN_DIR

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DLFCN_DIR

    # Getting and building LIB_DL
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DLFCN_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    wget --no-check-certificate $SOURCE_URL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    $ZIPTOOL $SOURCE_ARCHIVE -o$SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DLFCN_DIR
    pwd
    echo -e $GREEN  configure and build libdl.dll $NORMAL
     echo -e $YELLOW && ./configure --prefix=/ --libdir=/lib --incdir=/include && make && make install &&  echo -e $NORMAL
    echo
#========[Finish with LIB_DL]===================================
fi

if $BUILD_SPATIALITE ; then
#========[Start with SPATIALITE]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='spatialite'
    LIBNAMEVERSION_DIR='libspatialite-4.2.0'
    SOURCE_ARCHIVE='libspatialite-4.2.0.tar.gz'
    SOURCE_URL='http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.2.0.tar.gz'
    INCLUDE_SQLLITE=-I$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_SQLLITE_NAME_DIR/$LIB_SQLLITE_NAMEVERSION_DIR/win32/include
    INCLUDE_PROJ=-I$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_PROJ4_NAME_DIR/$LIB_PROJ4_NAMEVERSION_DIR/win32/include
    INCLUDE_FREEXL=-I$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_FREEXL_NAME_DIR/$LIB_FREEXL_NAMEVERSION_DIR/win32/include
    INCLUDE_GEOS=-I$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_GEOS_NAME_DIR/$LIB_GEOS_NAMEVERSION_DIR/win32/include
    INCLUDE_ICONV=-I$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIBNAME_ICONV_DIR/$LIBNAMEVERSION_ICONV_DIR/win32/include
        
    LIB_SQLLITE_LIB=-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_SQLLITE_NAME_DIR/$LIB_SQLLITE_NAMEVERSION_DIR/win32/lib
    LIB_PROJ_LIB=-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_PROJ4_NAME_DIR/$LIB_PROJ4_NAMEVERSION_DIR/win32/lib
    LIB_FREEXL_LIB=-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_FREEXL_NAME_DIR/$LIB_FREEXL_NAMEVERSION_DIR/win32/lib
    LIB_GEOS_LIB=-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_GEOS_NAME_DIR/$LIB_GEOS_NAMEVERSION_DIR/win32/lib
    LIB_ICONV_LIB=-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIBNAME_ICONV_DIR/$LIBNAMEVERSION_ICONV_DIR/win32/lib
    
    LIB_SQLLITE=-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_SQLLITE_NAME_DIR/$LIB_SQLLITE_NAMEVERSION_DIR/win32/bin
    LIB_PROJ=-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_PROJ4_NAME_DIR/$LIB_PROJ4_NAMEVERSION_DIR/win32/bin
    LIB_FREEXL=-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_FREEXL_NAME_DIR/$LIB_FREEXL_NAMEVERSION_DIR/win32/bin
    LIB_GEOS=-L$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_GEOS_NAME_DIR/$LIB_GEOS_NAMEVERSION_DIR/win32/bin
    
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIBNAME_DIR/$LIBNAMEVERSION_DIR/$ARCH

    # Getting and building SPATIALITE
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SPATIALITE
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of SPATIALITE
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
    pwd
    echo -e $GREEN  configure SPATIALITE makefiles $NORMAL
  
    export CPPFLAGS="$INCLUDE_SQLLITE $INCLUDE_PROJ $INCLUDE_FREEXL $INCLUDE_ICONV $INCLUDE_GEOS"
    export LDFLAGS="-L/c/Tools/MinGW-MSYS/msys/1.0/lib $LIB_SQLLITE_LIB $LIB_PROJ_LIB $LIB_FREEXL_LIB $LIB_ICONV_LIB $LIB_GEOS_LIB"
    export PKG_CONFIG_PATH=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_XML_NAME_DIR/$LIB_XML_NAMEVERSION_DIR/win32/lib/pkgconfig/
    echo -e $YELLOW && ./configure --with-geosconfig=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIB_GEOS_NAME_DIR/$LIB_GEOS_NAMEVERSION_DIR/win32/bin/geos-config --prefix=$BIN_INSTALL_DIR &&  echo -e $NORMAL
    echo -e $GREEN  build binaries $NORMAL
    $MAKETOOL && $MAKETOOL install-strip
    echo
#========[Finish with SPATIALITE]===================================
fi

if $BUILD_SPATIALINDEX ; then
#========[Start with SPATIALINDEX]===================================
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='spatialindex'
    LIBNAMEVERSION_DIR='spatialindex-src-1.8.4'
    SOURCE_ARCHIVE='spatialindex-src-1.8.4.tar.gz'
    SOURCE_URL='http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.4.tar.gz'


    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/Gis/$LIBNAME_DIR/$LIBNAMEVERSION_DIR/$ARCH

    # Getting and building SPATIALINDEX
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SPATIALINDEX
    rm -rf $SOURCE_EXTRACT_DIR
    #remove the previous build binaries  of SPATIALINDEX
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL
    
    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure SPATIALINDEX makefiles $NORMAL
    rm -rf build
    mkdir -p build
    cd build
    $CMAKE_TOOL "$CMAKE_GENERATOR_NAME" ../ -DCMAKE_INSTALL_PREFIX=$BIN_INSTALL_DIR
    echo -e $GREEN  build binaries $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
#========[Finish with SPATIALINDEX]===================================
fi

#========[Start with QWT]===================================
LIB_QWT_NAME_DIR='qwt'
LIB_QWT_NAMEVERSION_DIR='qwt-6.1.1'
SOURCE_QWT_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/$LIB_QWT_NAME_DIR
BIN_QWT_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/$LIB_QWT_NAME_DIR/$LIB_QWT_NAMEVERSION_DIR/$ARCH
if $GET_QWT ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='qwt-6.1.1.tar.bz2'
    SOURCE_URL='http://downloads.sourceforge.net/project/qwt/qwt/6.1.1/qwt-6.1.1.tar.bz2'
    BIN_QWT_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/$LIB_QWT_NAME_DIR/$LIB_QWT_NAMEVERSION_DIR/$ARCH
    
    # Getting QWT
    echo && echo -e $GREEN  Getting $LIB_QWT_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of QWT
    rm -rf $SOURCE_QWT_EXTRACT_DIR/$LIB_QWT_NAMEVERSION_DIR
    #remove the previous build binaries  of QWT
    rm -rf $BIN_QWT_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_QWT_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_QWT_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -xjf $SOURCE_ARCHIVE -C $SOURCE_QWT_EXTRACT_DIR
    
    cd $SOURCE_QWT_EXTRACT_DIR/$LIB_QWT_NAMEVERSION_DIR
    echo && echo "Change the QWT_INSTALL_PREFIX to " $BIN_QWT_INSTALL_DIR " in the  qwtconfig.pri file" 
    SED_SCRIPT='s|QWT_INSTALL_PREFIX .*= [Cc]:\/[A-Za-z\$_-]*|QWT_INSTALL_PREFIX = '$BIN_QWT_INSTALL_DIR'|g'
    sed -i "$SED_SCRIPT" qwtconfig.pri
#========[Finish with QWT]===================================
fi

if $BUILD_QWT ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    # cd to extracted directory
    cd $SOURCE_QWT_EXTRACT_DIR/$LIB_QWT_NAMEVERSION_DIR
    #pwd
    echo && echo -e $GREEN  configure $LIB_QWT_NAMEVERSION_DIR $NORMAL
    $QMAKE ./qwt.pro
    echo -e $GREEN  build binaries $NORMAL
    $MINGW_MAKETOOL && $MINGW_MAKETOOL install
    echo
#========[Finish with QWT]===================================
fi

#========[Start with QWT_POLAR]===================================
LIB_QWTPOLAR_NAME_DIR='qwtpolar'
LIB_QWTPOLAR_NAMEVERSION_DIR='qwtpolar-1.1.1'
SOURCE_QWTPOLAR_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/$LIB_QWTPOLAR_NAME_DIR
if $GET_QWTPOLAR ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='qwtpolar-1.1.1.tar.bz2'
    SOURCE_URL='http://downloads.sourceforge.net/project/qwtpolar/qwtpolar/1.1.1/qwtpolar-1.1.1.tar.bz2'
    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/$LIB_QWTPOLAR_NAME_DIR/$LIB_QWTPOLAR_NAMEVERSION_DIR/$ARCH
    
    # Getting QWTPOLAR
    echo && echo -e $GREEN  Getting QWTPOLAR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of QWTPOLAR
    rm -rf $SOURCE_QWTPOLAR_EXTRACT_DIR/$LIB_QWTPOLAR_NAMEVERSION_DIR
    #remove the previous build binaries  of QWTPOLAR
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_QWTPOLAR_EXTRACT_DIR
    #make the install directory
    mkdir -p $BIN_INSTALL_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -xjf $SOURCE_ARCHIVE -C $SOURCE_QWTPOLAR_EXTRACT_DIR
    echo -e $RED Edit the qwtpolarconfig.pri file to install the binaries in $BIN_INSTALL_DIR $NORMAL
    cd $SOURCE_QWTPOLAR_EXTRACT_DIR/$LIB_QWTPOLAR_NAMEVERSION_DIR
    #pwd
    #echo && echo "Change the QWT_POLAR_INSTALL_PREFIX to " $BIN_INSTALL_DIR " in the  qwtpolarconfig.pri file" 
    SED_SCRIPT='s|QWT_POLAR_INSTALL_PREFIX .*= [Cc]:\/[A-Za-z\$_-]*|QWT_POLAR_INSTALL_PREFIX = '$BIN_INSTALL_DIR'|g'
    sed -i "$SED_SCRIPT" qwtpolarconfig.pri
#========[Finish with QWTPOLAR Getting Source ]===================================
fi

if $BUILD_QWTPOLAR ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    export QMAKEFEATURES=$BIN_QWT_INSTALL_DIR/features 
    # cd to extracted directory
    cd $SOURCE_QWTPOLAR_EXTRACT_DIR/$LIB_QWTPOLAR_NAMEVERSION_DIR
    #pwd
    echo && echo -e $GREEN Build $LIB_QWTPOLAR_NAMEVERSION_DIR $NORMAL
    echo -e $RED Add QMAKEFEATURES $BIN_QWT_INSTALL_DIR/features to tell qmake where the qwt.prf file is located $NORMAL
    QMAKE_OPTIONS='-set QMAKEFEATURES '$BIN_QWT_INSTALL_DIR'/features'
    $QMAKE $QMAKE_OPTIONS
    echo -e $GREEN Generate the makefiles $NORMAL  
    $QMAKE $QMAKE_BUILD_OPTIONS ./qwtpolar.pro
    echo -e $GREEN  build binaries $NORMAL
    $MINGW_MAKETOOL && $MINGW_MAKETOOL install
    echo
#========[Finish with QWTPOLAR]===================================
fi


