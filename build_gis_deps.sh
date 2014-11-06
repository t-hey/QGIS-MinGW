#! /bin/bash

#In the root dir we will extract all the source and build the dependencies 
ROOT_DIR='/c/cpp/dev'
#Setup the downloads directory for downloading the Source 
DOWNLOAD_DIR=$ROOT_DIR/downloads
#In this dir binaries and include files will be extracted eg.Postgres 
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
BUILD_ZLIB=false #optional

BUILD_GEOS=false #Build with cmake, i get link errors when configure generate the makefiles
BUILD_FREEXL=false
BUILD_PROJ4=false
BUILD_SQLite=false
BUILD_GSL=false
BUILD_EXPAT=true
BUILD_POSTGRES=false
BUILD_FLEX=false   #optional
BUILD_BISON=false  #optional
BUILD_XML2=false
BUILD_ICONV=false
BUILD_SPATIALITE=false
BUILD_SPATIALINDEX=false #Build it with CMAKE the configure does not work
BUILD_GDAL=false
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
if [[ $QMAKE = '' ]]; then
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

#********************************[Build ZLIB]***********************************
if $BUILD_ZLIB ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR
    LIB_NAME_DIR='zlib'
    LIB_NAMEVERSION_DIR='zlib-1.2.8'
    SOURCE_ARCHIVE='zlib-1.2.8.tar.gz'
    SOURCE_URL='http://zlib.net/zlib-1.2.8.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/$LIB_NAME_DIR

    # Getting and building ZLIB
    echo && echo -e $GREEN  Getting and building $LIB_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of ZLIB
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_NAMEVERSION_DIR
    #pwd
    
    echo -e $GREEN  Build LIB_NAMEVERSION_DIR $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    export BINARY_PATH=/usr/local/bin 
    export INCLUDE_PATH=/usr/local/include
    export LIBRARY_PATH=/usr/local/lib 
    $MINGW_MAKETOOL -f win32/Makefile.gcc && $MINGW_MAKETOOL install -f win32/Makefile.gcc SHARED_MODE=1
    echo
fi
#*******************************[Build  ZLIB]***********************************

#*******************************[Build GEOS]************************************
LIB_GEOS_NAME_DIR='geos'
LIB_GEOS_NAMEVERSION_DIR='geos-3.4.2'
if $BUILD_GEOS ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='geos-3.4.2.tar.bz2'
    SOURCE_URL='http://download.osgeo.org/geos/geos-3.4.2.tar.bz2'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_GEOS_NAME_DIR

    # Getting and building GEOS
    echo && echo -e $GREEN  Getting and Building $LIB_GEOS_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of GEOS
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -xjf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_GEOS_NAMEVERSION_DIR
    #pwd
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    export "CXXFLAGS=-DHAVE_STD_ISNAN=1 -DHAVE_LONG_LONG_INT_64=1 -DGEOS_ENABLE_INLINE=ON -DGEOS_ENABLE_TESTS=ON"
    echo -e $YELLOW && ./configure && echo -e $NORMAL
    echo -e $RED Fix the library search path in the generated libtool script $NORMAL
    sed -i "s/\/lib'/\/lib/" libtool
    make && make install-strip
    echo
fi
#*******************************[Build GEOS]************************************

#*******************************[Build FREEXL]**********************************
LIB_FREEXL_NAME_DIR='freexl'
LIB_FREEXL_NAMEVERSION_DIR='freexl-1.0.0g'
if $BUILD_FREEXL ; then

    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='freexl-1.0.0g.tar.gz'
    SOURCE_URL='http://www.gaia-gis.it/gaia-sins/freexl-1.0.0g.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_FREEXL_NAME_DIR

    # Getting and building FREEXL
    echo && echo -e $GREEN  Getting and building $LIB_FREEXL_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of FREEXL
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_FREEXL_NAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure  makefiles $NORMAL
    echo -e $YELLOW && ./configure && echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MINGW_MAKETOOL && $MINGW_MAKETOOL install
    echo
fi
#*******************************[Build FREEXL]**********************************

#*******************************[Build PROJ4]***********************************
LIB_PROJ4_NAME_DIR='proj4'
LIB_PROJ4_NAMEVERSION_DIR='proj-4.8.0'
if $BUILD_PROJ4 ; then

    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='proj-4.8.0.tar.gz'
    SOURCE_URL='http://download.osgeo.org/proj/proj-4.8.0.tar.gz'
  
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_PROJ4_NAME_DIR

    # Getting and building PROJ4
    echo && echo -e $GREEN  Getting and building $LIB_PROJ4_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of PROJ4
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL
    
    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR

    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_PROJ4_NAMEVERSION_DIR
    pwd
    echo -e $GREEN  configure makefiles $NORMAL
    echo -e $YELLOW && ./configure && echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
fi
#*******************************[Build PROJ4]***********************************

#*******************************[Build libXml2]*********************************
LIB_XML_NAME_DIR='libxml2'
LIB_XML_NAMEVERSION_DIR='libxml2-2.9.2'
if $BUILD_XML2 ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='libxml2-2.9.2.tar.gz'
    SOURCE_URL='http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz'

    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_XML_NAME_DIR

    # Getting and building libXml2
    echo && echo -e $GREEN  Getting and building $LIB_XML_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of libXml2
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_XML_NAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure libXml2 makefiles $NORMAL
    echo -e $YELLOW && ./configure --without-python &&  echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install
fi
#*******************************[Build libXml2]*********************************

#*******************************[Build Postgres]********************************
LIBNAME_PG_DIR='postgres'
LIB_PG_NAMEVERSION_DIR='postgresql-9.3.5-1'
if $BUILD_POSTGRES ; then
    #We are just extracting the postgres binaries not building postres
    #Change to downloads folder
    cd $DOWNLOAD_DIR
    
    echo && echo -e $GREEN  Getting and extracting $LIB_PG_NAMEVERSION_DIR $NORMAL
    BINARY_ARCHIVE='postgresql-9.3.5-1-windows-binaries.zip'
    SOURCE_URL='http://get.enterprisedb.com/postgresql/postgresql-9.3.5-1-windows-binaries.zip'

    BIN_INSTALL_DIR=$ROOT_DIR/$LIBSDEP_DIR/$LIBNAME_PG_DIR/$LIB_PG_NAMEVERSION_DIR/$ARCH

    echo && echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous ---------------- Build Binaries --------------------  of Postgres
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the install directory
    mkdir -p $BIN_INSTALL_DIR
    pwd
    echo -e $GREEN  Extract the binaries for $LIB_PG_NAMEVERSION_DIR $NORMAL
    #Extract the zip file
    $ZIPTOOL $BINARY_ARCHIVE -o$BIN_INSTALL_DIR
    echo -e $RED We have to rename the pthread.h file to not get redefinition of 'struct timespec' when compiling GDAL later $NORMAL
    mv $BIN_INSTALL_DIR/pgsql/include/pthread.h $BIN_INSTALL_DIR/pgsql/include/pthread.h.backup
    echo -e $RED Copy the include\server\port\win32\* to the /usr/local/include dir for QGis to find $NORMAL
    cp --recursive $BIN_INSTALL_DIR/pgsql/include/server/port/win32/* /usr/local/include/
    echo
fi
#*******************************[Build Postgres]********************************

#*******************************[Build SQLite]**********************************
LIB_SQLLITE_NAME_DIR='sqlite'
LIB_SQLLITE_NAMEVERSION_DIR='sqlite-3.8.7'
if $BUILD_SQLite ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='sqlite-autoconf-3080700.tar.gz'
    SOURCE_URL='http://www.sqlite.org/2014/sqlite-autoconf-3080700.tar.gz'
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_SQLLITE_NAME_DIR

    # Getting and building SQLite
    echo && echo -e $GREEN  Getting and building $NORMAL $LIB_SQLLITE_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SQLite
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/sqlite-autoconf-3080700
    #pwd
    echo -e $GREEN  configure makefiles $NORMAL
    echo -e $YELLOW && ./configure &&  echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
fi
#*******************************[Build SQLite]**********************************

#*******************************[Build Expat]***********************************
LIB_EXPAT_NAME_DIR='expat'
LIB_EXPAT_NAMEVERSION_DIR='expat-2.1.0'
if $BUILD_EXPAT ; then
     #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='expat-2.1.0.tar.gz'
    SOURCE_URL='http://sourceforge.net/projects/expat/files/expat/2.1.0/expat-2.1.0.tar.gz'
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIB_EXPAT_NAME_DIR

    # Getting and building Expat
    echo && echo -e $GREEN  Getting and building $LIB_EXPAT_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of Expat
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_EXPAT_NAMEVERSION_DIR
    #pwd
    echo -e $GREEN configure Expat makefiles $NORMAL
    echo -e $YELLOW && ./configure &&  echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install
fi
#*******************************[Build Expat]***********************************

#*******************************[Build GSL]*************************************
if $BUILD_GSL ; then
     #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='gsl'
    LIBNAMEVERSION_DIR='gsl-1.16'
    SOURCE_ARCHIVE='gsl-1.16.tar.gz'
    SOURCE_URL='ftp://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz'
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR

    # Getting and building GSL
    echo && echo -e $GREEN  Getting and building $NORMAL $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of GSL
    rm -rf $SOURCE_EXTRACT_DIR
    
    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure GSL makefiles $NORMAL
    echo -e $YELLOW && ./configure &&  echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
fi
#*******************************[Build GSL]*************************************

#*******************************[Build FLEX]************************************
if $BUILD_FLEX ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='flex'
    LIBNAMEVERSION_DIR='flex-2.5.4a'
    BINARY_ARCHIVE='flex-2.5.4a-1-bin.zip'
    SOURCE_URL='http://downloads.sourceforge.net/project/gnuwin32/flex/2.5.4a-1/flex-2.5.4a-1-bin.zip'
    BIN_INSTALL_DIR=/usr/local
    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #Extract the zip file
    echo -e $GREEN  Extract the binaries for $LIBNAMEVERSION_DIR $NORMAL
    $ZIPTOOL $BINARY_ARCHIVE -o$BIN_INSTALL_DIR
    echo
fi
#*******************************[Build FLEX]************************************

#*******************************[Build BISON]***********************************
if $BUILD_BISON ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='bison'
    LIBNAMEVERSION_DIR='bison-2.4.1'
    BINARY_ARCHIVE='bison-2.4.1-bin.zip'
    SOURCE_URL='http://downloads.sourceforge.net/project/gnuwin32/bison/2.4.1/bison-2.4.1-bin.zip'
    BIN_INSTALL_DIR=/usr/local

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #Extract the zip file
    echo -e $GREEN  Extract the binaries for $LIBNAMEVERSION_DIR $NORMAL
    $ZIPTOOL $BINARY_ARCHIVE -o$BIN_INSTALL_DIR
    echo
fi
#*******************************[Build BISON]***********************************

#*******************************[Build ICONV]***********************************
LIBNAME_ICONV_DIR='iconv'
LIBNAMEVERSION_ICONV_DIR='libiconv-1.14'
if $BUILD_ICONV ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='libiconv-1.14.tar.gz'
    SOURCE_URL='http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz'
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_ICONV_DIR

    # Getting and building ICONV
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_ICONV_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of ICONV
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_ICONV_DIR
    #pwd
    echo -e $GREEN  configure ICONV makefiles $NORMAL
    echo -e $YELLOW && ./configure && echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
fi
#*******************************[Build ICONV]***********************************

#*******************************[Build LIB_DL]**********************************
if $BUILD_LIB_DL ; then
    #Change to downloads folder
    echo && echo -e $YELLOW We need to build the libld.dll for spatialite $NORMAL
    echo -e $YELLOW The libld.dll does not ship with the MSYS so we have to get the source and build it $NORMAL
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
    echo -e $YELLOW &&  ./configure --libdir=/lib --incdir=/include &&  echo -e $NORMAL
    make && make install 
    echo
fi
#*******************************[Build LIB_DL]**********************************

#*******************************[Build SPATIALITE]******************************
if $BUILD_SPATIALITE ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='spatialite'
    LIBNAMEVERSION_DIR='libspatialite-4.2.0'
    SOURCE_ARCHIVE='libspatialite-4.2.0.tar.gz'
    SOURCE_URL='http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.2.0.tar.gz'
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR

    # Getting and building SPATIALITE
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SPATIALITE
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    ##echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
    pwd
    echo -e $GREEN  configure SPATIALITE makefiles $NORMAL
    export "CFLAGS=-I/usr/local/include"
    export "LDFLAGS=-L/usr/local/lib"
    export "PKG_CONFIG_PATH=/usr/local/lib/pkgconfig"
    echo -e $YELLOW && ./configure --target=mingw32 #--enable-lwgeom=yes 
    echo -e $NORMAL
    make && make install-strip
    
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install-strip
    echo
fi
#*******************************[Build SPATIALITE]******************************

#*******************************[Build SPATIALINDEX]****************************
if $BUILD_SPATIALINDEX ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='spatialindex'
    LIBNAMEVERSION_DIR='spatialindex-src-1.8.4'
    SOURCE_ARCHIVE='spatialindex-src-1.8.4.tar.gz'
    SOURCE_URL='http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.4.tar.gz'
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR

    # Getting and building SPATIALINDEX
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SPATIALINDEX
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    ##echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL
    
    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

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
    $CMAKE_TOOL "$CMAKE_GENERATOR_NAME" ../ -DCMAKE_INSTALL_PREFIX=/usr/local
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo -e $RED Copy the linked dll from /usr/local to the /usr/local/bin $NORMAL
    cp /usr/local/lib*.dll /usr/local/bin
    echo
fi
#*******************************[Build SPATIALINDEX]****************************

#*******************************[Build GDAL]************************************
if $BUILD_GDAL ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    LIBNAME_DIR='gdal'
    LIBNAMEVERSION_DIR='gdal-1.11.1'
    SOURCE_ARCHIVE='gdal1111.zip'
    SOURCE_URL='http://download.osgeo.org/gdal/1.11.1/gdal1111.zip'
    SOURCE_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR
    
    # Getting and building GDAL
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of gdal
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    $ZIPTOOL $SOURCE_ARCHIVE -o$SOURCE_EXTRACT_DIR

    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure makefiles $NORMAL
    echo -e $YELLOW && ./configure --with-pg=$ROOT_DIR/$LIBSDEP_DIR/$LIBNAME_PG_DIR/$LIB_PG_NAMEVERSION_DIR/win32/pgsql/bin/pg_config.exe --with-freexl=/usr/local/lib  && echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
fi
#*******************************[Build GDAL]************************************

#*******************************[Build QWT]*************************************
LIB_QWT_NAME_DIR='qwt'
LIB_QWT_NAMEVERSION_DIR='qwt-6.1.1'
SOURCE_QWT_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/$LIB_QWT_NAME_DIR
if $GET_QWT ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='qwt-6.1.1.tar.bz2'
    SOURCE_URL='http://downloads.sourceforge.net/project/qwt/qwt/6.1.1/qwt-6.1.1.tar.bz2'
    
    # Getting QWT
    echo && echo -e $GREEN  Getting $LIB_QWT_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of QWT
    rm -rf $SOURCE_QWT_EXTRACT_DIR/$LIB_QWT_NAMEVERSION_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_QWT_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -xjf $SOURCE_ARCHIVE -C $SOURCE_QWT_EXTRACT_DIR
    
    cd $SOURCE_QWT_EXTRACT_DIR/$LIB_QWT_NAMEVERSION_DIR
    echo && echo "Change the QWT_INSTALL_PREFIX to " $BIN_QWT_INSTALL_DIR " in the  qwtconfig.pri file" 
    SED_SCRIPT='s|QWT_INSTALL_PREFIX .* [Cc]:\/[A-Za-z\$_-]*|QWT_INSTALL_PREFIX = '/usr/local'|g'
    sed -i "$SED_SCRIPT" qwtconfig.pri
fi

if $BUILD_QWT ; then
    # cd to extracted directory
    cd $SOURCE_QWT_EXTRACT_DIR/$LIB_QWT_NAMEVERSION_DIR
    #pwd
    echo && echo -e $GREEN  configure $LIB_QWT_NAMEVERSION_DIR $NORMAL
    $QMAKE ./qwt.pro
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MINGW_MAKETOOL && $MINGW_MAKETOOL install
    echo
fi
#*******************************[Build QWT]*************************************

#*******************************[Build QWT_POLAR]*******************************
LIB_QWTPOLAR_NAME_DIR='qwtpolar'
LIB_QWTPOLAR_NAMEVERSION_DIR='qwtpolar-1.1.1'
SOURCE_QWTPOLAR_EXTRACT_DIR=$ROOT_DIR/$LIBSEXTERNAL_DIR/$LIB_QWTPOLAR_NAME_DIR
if $GET_QWTPOLAR ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='qwtpolar-1.1.1.tar.bz2'
    SOURCE_URL='http://downloads.sourceforge.net/project/qwtpolar/qwtpolar/1.1.1/qwtpolar-1.1.1.tar.bz2'
    
    # Getting QWTPOLAR
    echo && echo -e $GREEN  Getting QWTPOLAR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of QWTPOLAR
    rm -rf $SOURCE_QWTPOLAR_EXTRACT_DIR/$LIB_QWTPOLAR_NAMEVERSION_DIR

    #Getting the source from the internet
    #echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_QWTPOLAR_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -xjf $SOURCE_ARCHIVE -C $SOURCE_QWTPOLAR_EXTRACT_DIR
    echo -e $RED Edit the qwtpolarconfig.pri file to install the binaries in $BIN_INSTALL_DIR $NORMAL
    cd $SOURCE_QWTPOLAR_EXTRACT_DIR/$LIB_QWTPOLAR_NAMEVERSION_DIR
    pwd
    #echo && echo "Change the QWT_POLAR_INSTALL_PREFIX to " $BIN_INSTALL_DIR " in the  qwtpolarconfig.pri file" 
    SED_SCRIPT='s|QWT_POLAR_INSTALL_PREFIX .* [Cc]:\/[A-Za-z\$_-]*|QWT_POLAR_INSTALL_PREFIX = /usr/local|g'
    sed -i "$SED_SCRIPT" qwtpolarconfig.pri
fi

if $BUILD_QWTPOLAR ; then
    # cd to extracted directory
    cd $SOURCE_QWTPOLAR_EXTRACT_DIR/$LIB_QWTPOLAR_NAMEVERSION_DIR
    #pwd
    echo && echo -e $GREEN Build $LIB_QWTPOLAR_NAMEVERSION_DIR $NORMAL
    echo -e $RED Add QMAKEFEATURES $BIN_QWT_INSTALL_DIR/features to tell qmake where the qwt.prf file is located $NORMAL
    #$QMAKE $QMAKE_OPTIONS
    echo -e $GREEN Generate the makefiles $NORMAL  
    export QMAKEFEATURES=/usr/local/features 
    QMAKE_OPTIONS='-set QMAKEFEATURES=/usr/local/features'
    #$QMAKE $QMAKE_BUILD_OPTIONS ./qwtpolar.pro
    #echo $QMAKE $QMAKE_OPTIONS ./qwtpolar.pro
    #$QMAKE $QMAKE_OPTIONS ./qwtpolar.pro
    $QMAKE ./qwtpolar.pro
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MINGW_MAKETOOL && $MINGW_MAKETOOL install
    echo
fi
#*******************************[Build QWT_POLAR]*******************************



