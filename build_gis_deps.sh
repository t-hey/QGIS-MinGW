#! /bin/bash

#In the root dir we will extract all the source and build the dependencies 
ROOT_DIR='/c/cpp/dev'
#Setup the downloads directory for downloading the Source 
DOWNLOAD_DIR=$ROOT_DIR/downloads
#In this dir binaries and include files will be extracted eg.Postgres 
LIBSDEP_DIR=$ROOT_DIR/LibsDep_
#In this dir all the source for the dependencies will extracted
LIBSEXTERNAL_DIR=$ROOT_DIR/LibsExternal_
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
CMAKE_EXE='cmake'
CMAKE_TOOL=$CMAKE_EXE' -G'
#Build options for qmake
QMAKE_BUILD_OPTIONS='-makefile -spec win32-g++'
#Path to the qmake exe
QMAKE='C:/Qt/Qt5.4.1/5.4/mingw491_32/bin/qmake'
#Path to mingw installation
MINGW_INSTALL_DIR='/c/Qt/Qt5.4.1/Tools/mingw491_32'
PACKAGE_CONFIG_TOOL='pkg-config.exe'
#Path to MSYS mingw-get.exe utility
MINGW_GET_UTIL_DIR='/c/Tools/MinGW-MSYS/bin'
MINGW_GET_UTIL='/c/Tools/MinGW-MSYS/bin/mingw-get.exe'
#Path to MINGW python
PYTHON_EXE_PATH=$MINGW_INSTALL_DIR/opt/bin
PYTHON_LIB_PATH=$MINGW_INSTALL_DIR/opt/lib/python2.7


#************* Flags for which dependencies to build, by default all is false **************
BUILD_ZLIB=false #optional
BUILD_GEOS=false #Build with cmake, i get link errors when configure generate the makefiles
BUILD_ICONV=false
BUILD_FREEXL=false
BUILD_PROJ4=false
BUILD_XML2=false
BUILD_POSTGRES=false
BUILD_SQLite=false
BUILD_EXPAT=false
BUILD_GSL=false
BUILD_FLEX=false   #optional
BUILD_BISON=false  #optional
BUILD_SPATIALITE=false
BUILD_SPATIALINDEX=false #Build it with CMAKE the configure does not work
BUILD_GDAL=false
GET_QWT=false
BUILD_QWT=false
GET_QWTPOLAR=false
BUILD_QWTPOLAR=false
BUILD_SIP=true
BUILD_PYQT=false

#************** Define colors *********************
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PURPLE="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"

#Check for pkg-config tool and install if necessary.
if type $PACKAGE_CONFIG_TOOL 2>/dev/null; then
    echo "$PACKAGE_CONFIG_TOOL is installed"
else
   [ ! -f $MINGW_GET_UTIL ] && echo -e $RED "$MINGW_GET_UTIL is not present, dependencies for $PACKAGE_CONFIG_TOOL will not be able to install" $NORMAL && exit
  
   echo -e $RED "$PACKAGE_CONFIG_TOOL is not installed" $NORMAL; 
   echo -e $GREEN "Installing $PACKAGE_CONFIG_TOOL...." 
   cd $DOWNLOAD_DIR
   echo -e $GREEN "Downloading pkg-config_0.23-3_win32 binaries..."
   PACKAGE_CONFIG_TOOL_URL='http://ftp.gnome.org/pub/gnome/binaries/win32/dependencies/pkg-config_0.23-3_win32.zip'
   [ ! -f pkg-config_0.23-3_win32.zip ] && echo -e $CYAN && wget $PACKAGE_CONFIG_TOOL_URL && echo -e $NORMAL 
   #Extract the zip file
   [ -f pkg-config_0.23-3_win32.zip ] && $ZIPTOOL pkg-config_0.23-3_win32.zip -opkg-config_0.23-3_win32 > nul
   [ -d pkg-config_0.23-3_win32 ] && cp pkg-config_0.23-3_win32/bin/$PACKAGE_CONFIG_TOOL $MINGW_INSTALL_DIR/bin
   
   echo -e $GREEN "Downloading glib_2.28.1-1_win32 binaries..."
   GLIB_DLL_URL='http://ftp.gnome.org/pub/gnome/binaries/win32/glib/2.28/glib_2.28.1-1_win32.zip'
   [ ! -f glib_2.28.1-1_win32.zip ] && echo -e $CYAN && wget $GLIB_DLL_URL && echo -e $NORMAL 
   #Extract the zip file
   [ -f glib_2.28.1-1_win32.zip ] && $ZIPTOOL glib_2.28.1-1_win32.zip -oglib_2.28.1-1_win32 > nul
   [ -d glib_2.28.1-1_win32 ] && cp glib_2.28.1-1_win32/bin/libglib-2.0-0.dll $MINGW_INSTALL_DIR/bin
    
   echo -e $GREEN "Installing mingw32-libintl..." 
   [ -f $MINGW_GET_UTIL ] && echo on && $MINGW_GET_UTIL install mingw32-libintl
   cp $MINGW_GET_UTIL_DIR/libintl-8.dll $MINGW_INSTALL_DIR/bin/intl.dll   
   cp $MINGW_GET_UTIL_DIR/libiconv-2.dll $MINGW_INSTALL_DIR/bin/libiconv-2.dll
fi  

#Check binary paths
if [[ $QMAKE = '' ]]; then
    echo "You have to set the path to the qmake.exe"
    exit
else
    if [ ! -f "$QMAKE" ]; then
     echo -e $RED $QMAKE does not exist, fix the path value of the to the QMAKE variable in the script $NORMAL 
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
  echo "creating $DOWNLOAD_DIR"
  mkdir -p $DOWNLOAD_DIR
fi

echo -e $GREEN Checking if $LIBSDEP_DIR exist $NORMAL 
if [ ! -d "$LIBSDEP_DIR" ]; then
  echo "creating $LIBSDEP_DIR"
  mkdir -p $LIBSDEP_DIR
fi

echo -e $GREEN Checking if $LIBSEXTERNAL_DIR exist $NORMAL
if [ ! -d "$LIBSEXTERNAL_DIR" ]; then
  echo "creating $LIBSEXTERNAL_DIR"
  mkdir -p $LIBSEXTERNAL_DIR
fi

# Make sure that Wget and 7Zip is installed
if hash wget 2>/dev/null; then
    echo "wget is installed"
else
   echo "Install wget please. Use the MINGW-MSYS tool mingw-get.exe to install wget"; exit;     
fi

if type $ZIPTOOL 2>/dev/null; then
    echo "$ZIPTOOL is installed"
else
   echo "Install 7z please. Download 7Zip from http://www.7-zip.org/download.html and add it to the path."; exit;     
fi

if type $CMAKE_EXE 2>/dev/null; then
    echo "$$CMAKE_EXE is installed"
else
   echo "CMAKE is not installed. Download the latest version from http://www.cmake.org/download/ and install it and add it to the path."; exit;     
fi

#********************************[Build ZLIB]***********************************
if $BUILD_ZLIB ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR
    LIB_NAME_DIR='zlib'
    LIB_NAMEVERSION_DIR='zlib-1.2.8'
    SOURCE_ARCHIVE='zlib-1.2.8.tar.gz'
    SOURCE_URL='http://zlib.net/zlib-1.2.8.tar.gz'

    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/$LIB_NAME_DIR

    # Getting and building ZLIB
    echo && echo -e $GREEN  Getting and building $LIB_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of ZLIB
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL
    
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

    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIB_GEOS_NAME_DIR

    # Getting and building GEOS
    echo && echo -e $GREEN  Getting and Building $LIB_GEOS_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of GEOS
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

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

#*******************************[Build ICONV]***********************************
LIBNAME_ICONV_DIR='iconv'
LIBNAMEVERSION_ICONV_DIR='libiconv-1.14'
if $BUILD_ICONV ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='libiconv-1.14.tar.gz'
    SOURCE_URL='http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz'
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIBNAME_ICONV_DIR

    # Getting and building ICONV
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_ICONV_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of ICONV
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

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

#*******************************[Build FREEXL]**********************************
LIB_FREEXL_NAME_DIR='freexl'
LIB_FREEXL_NAMEVERSION_DIR=$LIB_FREEXL_NAME_DIR'-1.0.1'
if $BUILD_FREEXL ; then

    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE=$LIB_FREEXL_NAMEVERSION_DIR'.tar.gz'
    SOURCE_URL='http://www.gaia-gis.it/gaia-sins/freexl-sources/'$SOURCE_ARCHIVE

    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIB_FREEXL_NAME_DIR

    # Getting and building FREEXL
    echo && echo -e $GREEN  Getting and building $LIB_FREEXL_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of FREEXL
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

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
LIB_PROJ4_VERSION='4.9.1'
LIB_PROJ4_NAMEVERSION_DIR='proj-'$LIB_PROJ4_VERSION
if $BUILD_PROJ4 ; then

    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE=$LIB_PROJ4_NAMEVERSION_DIR'.tar.gz'
    SOURCE_URL='http://download.osgeo.org/proj/'$SOURCE_ARCHIVE
  
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIB_PROJ4_NAME_DIR

    # Getting and building PROJ4
    echo && echo -e $GREEN  Getting and building $LIB_PROJ4_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of PROJ4
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL
    
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

    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIB_XML_NAME_DIR

    # Getting and building libXml2
    echo && echo -e $GREEN  Getting and building $LIB_XML_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of libXml2
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIB_XML_NAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure libXml2 makefiles $NORMAL
    echo -e $YELLOW && ./configure --without-python  --with-zlib=/usr/local --with-lzma=/usr/local &&  echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install-strip
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

    BIN_INSTALL_DIR=$LIBSDEP_DIR/$LIBNAME_PG_DIR/$LIB_PG_NAMEVERSION_DIR/$ARCH

    echo && echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous ---------------- Build Binaries --------------------  of Postgres
    rm -rf $BIN_INSTALL_DIR

    #Getting the source from the internet
    [ ! -f $BINARY_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

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
LIB_SQLLITE_VERSION='3.8.10.1'
LIB_SQLLITE_NAMEVERSION_DIR=$LIB_SQLLITE_NAME_DIR'-'$LIB_SQLLITE_VERSION
if $BUILD_SQLite ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR

    SOURCE_ARCHIVE='sqlite-autoconf-3081001.tar.gz'
    SOURCE_URL='https://www.sqlite.org/2015/'$SOURCE_ARCHIVE
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIB_SQLLITE_NAME_DIR

    # Getting and building SQLite
    echo && echo -e $GREEN  Getting and building $NORMAL $LIB_SQLLITE_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SQLite
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget --no-check-certificate $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -zxvf $SOURCE_ARCHIVE -C $SOURCE_EXTRACT_DIR
    # cd to extracted directory
    SOURCE_EXTRACTED_DIR=`echo "$SOURCE_ARCHIVE" | sed -n 's/\([a-z0-9\-].*\)\.tar.gz/\1/p'` 
    cd $SOURCE_EXTRACT_DIR/$SOURCE_EXTRACTED_DIR 
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
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIB_EXPAT_NAME_DIR

    # Getting and building Expat
    echo && echo -e $GREEN  Getting and building $LIB_EXPAT_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of Expat
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

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
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR

    # Getting and building GSL
    echo && echo -e $GREEN  Getting and building $NORMAL $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of GSL
    rm -rf $SOURCE_EXTRACT_DIR
    
    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

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
    [ ! -f $BIN_INSTALL_DIR ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

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
    [ ! -f $BIN_INSTALL_DIR ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #Extract the zip file
    echo -e $GREEN  Extract the binaries for $LIBNAMEVERSION_DIR $NORMAL
    $ZIPTOOL $BINARY_ARCHIVE -o$BIN_INSTALL_DIR
    echo
fi
#*******************************[Build BISON]***********************************

#*******************************[Build LIB_DL]**********************************
if $BUILD_SPATIALITE ; then
    # Check if libdl.a is installed. 
    # When building spatialite the configure script somehow pick up that libld is installed, 
    # and add -ldl to the linklist of the examples in spatialite, 
    # then the build process crash if it is not present
    if [ ! -f "/lib/libdl.a" ]; then
     BUILD_LIB_DL=true 
    else
     BUILD_LIB_DL=false    
    fi 

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

        SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DLFCN_DIR

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
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR

    # Getting and building SPATIALITE
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SPATIALITE
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

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
    export "PKG_CONFIG=$MINGW_INSTALL_DIR/bin/$PACKAGE_CONFIG_TOOL"
    echo -e $RED && echo "CFLAGS=$CFLAGS"
    echo -e $RED && echo "LDFLAGS=$LDFLAGS"
    echo -e $RED && echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH"
    echo -e $RED && echo "PKG_CONFIG=$PKG_CONFIG"
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
    LIBNAME_VERSION='1.8.5'
    LIBNAMEVERSION_DIR=$LIBNAME_DIR'-src-'$LIBNAME_VERSION
    SOURCE_ARCHIVE=$LIBNAMEVERSION_DIR'.tar.gz'
    SOURCE_URL='http://download.osgeo.org/libspatialindex/'$SOURCE_ARCHIVE
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR

    # Getting and building SPATIALINDEX
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SPATIALINDEX
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL
    
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
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/Gis/$LIBNAME_DIR
    
    # Getting and building GDAL
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of gdal
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory and Extract the zip file
    [ ! -d $SOURCE_EXTRACT_DIR ] && mkdir -p $SOURCE_EXTRACT_DIR && $ZIPTOOL $SOURCE_ARCHIVE -o$SOURCE_EXTRACT_DIR

    # cd to extracted directory
    cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
    #pwd
    echo -e $GREEN  configure makefiles $NORMAL
    echo -e $YELLOW && ./configure --with-pg=$LIBSDEP_DIR/$LIBNAME_PG_DIR/$LIB_PG_NAMEVERSION_DIR/win32/pgsql/bin/pg_config.exe --with-freexl=/usr/local && echo -e $NORMAL
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MAKETOOL && $MAKETOOL install
    echo
fi
#*******************************[Build GDAL]************************************

#*******************************[Build QWT]*************************************
LIB_QWT_NAME_DIR='qwt'
LIB_QWT_VERSION='6.1.2'
LIB_QWT_NAMEVERSION_DIR=$LIB_QWT_NAME_DIR'-'$LIB_QWT_VERSION
SOURCE_QWT_EXTRACT_DIR=$LIBSEXTERNAL_DIR/$LIB_QWT_NAME_DIR
if $GET_QWT ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR
http://downloads.sourceforge.net/project/qwt/qwt/6.1.2/qwt-6.1.2.tar.bz2
    SOURCE_ARCHIVE=$LIB_QWT_NAMEVERSION_DIR'.tar.bz2'
    SOURCE_URL='http://downloads.sourceforge.net/project/'$LIB_QWT_NAME_DIR/$LIB_QWT_NAME_DIR/$LIB_QWT_VERSION/$SOURCE_ARCHIVE
    
    # Getting QWT
    echo && echo -e $GREEN  Getting $LIB_QWT_NAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of QWT
    rm -rf $SOURCE_QWT_EXTRACT_DIR/$LIB_QWT_NAMEVERSION_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory
    mkdir -p $SOURCE_QWT_EXTRACT_DIR

    #Extract the zip file
    echo -e $RED Extract the source $NORMAL
    tar -xjf $SOURCE_ARCHIVE -C $SOURCE_QWT_EXTRACT_DIR
    
    cd $SOURCE_QWT_EXTRACT_DIR/$LIB_QWT_NAMEVERSION_DIR
    echo && echo "Change the QWT_INSTALL_PREFIX to " $BIN_QWT_INSTALL_DIR " in the  qwtconfig.pri file" 
    SED_SCRIPT='s|QWT_INSTALL_PREFIX .* [Cc]:\/[A-Za-z\$_-]*|QWT_INSTALL_PREFIX = '/usr/local'|g'
    echo -e $GREEN && echo "SED_SCRIPT=$SED_SCRIPT"
    echo "Current working directory" && pwd
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
SOURCE_QWTPOLAR_EXTRACT_DIR=$LIBSEXTERNAL_DIR/$LIB_QWTPOLAR_NAME_DIR
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
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

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
    echo $QMAKE $QMAKE_OPTIONS ./qwtpolar.pro
    #$QMAKE $QMAKE_OPTIONS ./qwtpolar.pro
    $QMAKE ./qwtpolar.pro
    echo -e $GREEN  ---------------- Build Binaries -------------------- $NORMAL
    $MINGW_MAKETOOL && $MINGW_MAKETOOL install
    echo
fi
#*******************************[Build QWT_POLAR]*******************************

#*******************************[Build SIP]************************************
if $BUILD_SIP ; then
    #Change to downloads folder
    cd $DOWNLOAD_DIR
    LIBNAME_DIR='sip'
    LIB_VERSION='4.16.7'
    LIBNAMEVERSION_DIR=$LIBNAME_DIR'-'$LIB_VERSION
    SOURCE_ARCHIVE=$LIBNAMEVERSION_DIR'.zip'
    SOURCE_URL='http://sourceforge.net/projects/pyqt/files/'$LIBNAME_DIR/$LIBNAMEVERSION_DIR/$SOURCE_ARCHIVE
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/$LIBNAME_DIR
    
    # Getting and building SIP
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SIP
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory and Extract the zip file
    [ ! -d $SOURCE_EXTRACT_DIR ] && mkdir -p $SOURCE_EXTRACT_DIR && $ZIPTOOL $SOURCE_ARCHIVE -o$SOURCE_EXTRACT_DIR

	#Get the PyQt stuff 
	#Change to downloads folder
    cd $DOWNLOAD_DIR
    LIBNAME_DIR='PyQt'
    LIB_VERSION='5.4.1'
    LIBNAMEVERSION_DIR=$LIBNAME_DIR'-'$LIB_VERSION
    SOURCE_ARCHIVE=$LIBNAME_DIR'-gpl-'$LIB_VERSION'.zip'
    SOURCE_URL='http://sourceforge.net/projects/pyqt/files/PyQt5'/$LIBNAMEVERSION_DIR/$SOURCE_ARCHIVE
    SOURCE_EXTRACT_DIR=$LIBSEXTERNAL_DIR/$LIBNAME_DIR
    
    # Getting and building SIP
    echo && echo -e $GREEN  Getting and building $LIBNAMEVERSION_DIR $NORMAL
    #pwd
    echo -e $GREEN  removing previous stuff $NORMAL
    #remove the previous extracted files of SIP
    rm -rf $SOURCE_EXTRACT_DIR

    #Getting the source from the internet
    [ ! -f $SOURCE_ARCHIVE ] && echo -e $CYAN && wget $SOURCE_URL && echo -e $NORMAL

    #make the extraction directory and Extract the zip file
    [ ! -d $SOURCE_EXTRACT_DIR ] && mkdir -p $SOURCE_EXTRACT_DIR && $ZIPTOOL $SOURCE_ARCHIVE -o$SOURCE_EXTRACT_DIR
	
    [ ! -d $MINGW_INSTALL_DIR/opt/libs ] && mkdir -p $MINGW_INSTALL_DIR/opt/libs 
	[ ! -f $MINGW_INSTALL_DIR/opt/libs/libpython27.dll ] && cp $MINGW_INSTALL_DIR/opt/bin/libpython2.7.dll $MINGW_INSTALL_DIR/opt/libs/libpython27.dll
	
    # cd to extracted directory
    #cd $SOURCE_EXTRACT_DIR/$LIBNAMEVERSION_DIR
	echo
	echo -e $GREEN ATTENTION:
	echo -e $GREEN You have to open a cmd prompt and cd to where the $WHITE build_sip_pyqt.bat $GREEN is copied, \\n and execute the build_sip_pyqt.bat file. \\n It should be where you cloned the QGIS-MinGW repo.  $NORMAL
    echo
fi
#*******************************[Build SIP]************************************
