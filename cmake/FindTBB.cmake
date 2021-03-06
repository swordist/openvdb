#-*-cmake-*-
# - Find TBB
#
# Author : Nicholas Yue yue.nicholas@gmail.com
#
# This auxiliary CMake file helps in find the TBB headers and libraries
#
# TBB_FOUND                  set if TBB is found.
# TBB_INCLUDE_DIR            TBB's include directory
# TBB_tbb_LIBRARY            TBB libraries
# TBB_tbb_preview_LIBRARY    TBB_preview libraries (Mulitple Rendering Context)
# TBB_tbbmalloc_LIBRARY      TBBmalloc libraries (Mulitple Rendering Context)

FIND_PACKAGE ( PackageHandleStandardArgs )

# SET ( TBB_FOUND FALSE )

FIND_PATH( TBB_LOCATION include/tbb/tbb.h
  "$ENV{TBB_ROOT}"
  NO_DEFAULT_PATH
  NO_CMAKE_ENVIRONMENT_PATH
  NO_CMAKE_PATH
  NO_SYSTEM_ENVIRONMENT_PATH
  NO_CMAKE_SYSTEM_PATH
  )

FIND_PACKAGE_HANDLE_STANDARD_ARGS ( TBB
  REQUIRED_VARS TBB_LOCATION
  )

IF ( TBB_FOUND )

  SET( TBB_INCLUDE_DIR "${TBB_LOCATION}/include" CACHE STRING "TBB include directory")

  IF (APPLE)
	IF (TBB_FOR_CLANG)
      SET ( TBB_LIBRARY_DIR ${TBB_LOCATION}/lib/libc++ CACHE STRING "TBB library directory")
	ELSE ()
      SET ( TBB_LIBRARY_DIR ${TBB_LOCATION}/lib CACHE STRING "TBB library directory")
	ENDIF ()
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dylib")
	FIND_LIBRARY ( TBB_LIBRARY_PATH tbb PATHS ${TBB_LIBRARY_DIR} )
	FIND_LIBRARY ( TBB_PREVIEW_LIBRARY_PATH tbb_preview PATHS ${TBB_LIBRARY_DIR} )
	FIND_LIBRARY ( TBBMALLOC_LIBRARY_PATH tbbmalloc PATHS ${TBB_LIBRARY_DIR} )
	LIST ( APPEND TBB_LIBRARIES_LIST ${TBB_LIBRARY_PATH} ${TBBmx_LIBRARY_PATH} )
  ELSEIF (WIN32)
	IF (MSVC10)
      SET ( TBB_VC_DIR vc10 )
	ELSEIF (MSVC11)
      SET ( TBB_VC_DIR vc11 )
	ELSEIF (MSVC12)
      SET ( TBB_VC_DIR vc12 )
	ENDIF ( MSVC10)
	#  MESSAGE ( "TBB_VC_DIR = ${TBB_VC_DIR}" )
	SET (TBB_PATH_SUFFIXES intel64/${TBB_VC_DIR} )
	FIND_LIBRARY ( TBB_LIBRARY_PATH tbb PATHS ${TBB_LOCATION}/lib PATH_SUFFIXES ${TBB_PATH_SUFFIXES})
	FIND_LIBRARY ( TBB_PREVIEW_LIBRARY_PATH tbb_preview PATHS ${TBB_LOCATION}/lib  PATH_SUFFIXES ${TBB_PATH_SUFFIXES})
	FIND_LIBRARY ( TBBMALLOC_LIBRARY_PATH tbbmalloc PATHS ${TBB_LOCATION}/lib  PATH_SUFFIXES ${TBB_PATH_SUFFIXES})
	LIST ( APPEND TBB_LIBRARIES_LIST ${TBB_LIBRARY_PATH} ${TBBmx_LIBRARY_PATH} )
  ELSE (APPLE)
	# MESSAGE ( "CMAKE_COMPILER_IS_GNUCXX = ${CMAKE_COMPILER_IS_GNUCXX}")
	IF (${CMAKE_COMPILER_IS_GNUCXX})
	  IF ( TBB_MATCH_COMPILER_VERSION )
		STRING(REGEX MATCHALL "[0-9]+" GCC_VERSION_COMPONENTS ${CMAKE_CXX_COMPILER_VERSION})
		LIST(GET GCC_VERSION_COMPONENTS 0 GCC_MAJOR)
		LIST(GET GCC_VERSION_COMPONENTS 1 GCC_MINOR)
		# MESSAGE(STATUS ${GCC_MAJOR})
		# MESSAGE(STATUS ${GCC_MINOR})
		# MESSAGE ( "TBB CMAKE_CXX_COMPILER_VERSION = ${CMAKE_CXX_COMPILER_VERSION}")
		SET ( TBB_PATH_SUFFIXES intel64/gcc${GCC_MAJOR}.${GCC_MINOR} )
	  ELSE ()
		SET ( TBB_PATH_SUFFIXES intel64/gcc4.4 )
	  ENDIF ()
	ELSE ()
      MESSAGE ( FATAL_ERROR "Can't hanlde non-GCC compiler")
	ENDIF ()
	FIND_LIBRARY ( TBB_LIBRARY_PATH tbb PATHS ${TBB_LOCATION}/lib PATH_SUFFIXES ${TBB_PATH_SUFFIXES}
      NO_DEFAULT_PATH
      NO_CMAKE_ENVIRONMENT_PATH
      NO_CMAKE_PATH
      NO_SYSTEM_ENVIRONMENT_PATH
      NO_CMAKE_SYSTEM_PATH
	  )
	FIND_LIBRARY ( TBB_PREVIEW_LIBRARY_PATH tbb_preview PATHS ${TBB_LOCATION}/lib PATH_SUFFIXES ${TBB_PATH_SUFFIXES}
      NO_DEFAULT_PATH
      NO_CMAKE_ENVIRONMENT_PATH
      NO_CMAKE_PATH
      NO_SYSTEM_ENVIRONMENT_PATH
      NO_CMAKE_SYSTEM_PATH
	  )
	FIND_LIBRARY ( TBBMALLOC_LIBRARY_PATH tbbmalloc PATHS ${TBB_LOCATION}/lib PATH_SUFFIXES ${TBB_PATH_SUFFIXES}
      NO_DEFAULT_PATH
      NO_CMAKE_ENVIRONMENT_PATH
      NO_CMAKE_PATH
      NO_SYSTEM_ENVIRONMENT_PATH
      NO_CMAKE_SYSTEM_PATH
	  )
	LIST ( APPEND TBB_LIBRARIES_LIST ${TBB_LIBRARY_PATH} ${TBBmx_LIBRARY_PATH} )
  ENDIF (APPLE)

  GET_FILENAME_COMPONENT ( TBB_LIBRARY_DIR ${TBB_LIBRARY_PATH} PATH CACHE )

  SET( Tbb_TBB_LIBRARY ${TBB_LIBRARY_PATH} CACHE STRING "tbb library")
  SET( Tbb_TBB_PREVIEW_LIBRARY ${TBB_PREVIEW_LIBRARY_PATH} CACHE STRING "tbb_preview library")
  SET( Tbb_TBBMALLOC_LIBRARY ${TBBMALLOC_LIBRARY_PATH} CACHE STRING "tbbmalloc library")

ENDIF ( TBB_FOUND )
