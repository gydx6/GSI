macro( setHOST )
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/Cheyenne.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/Discover.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/Generic.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/Jet.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/S4.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/Theia.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/WCOSS-C.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/WCOSS-D.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/WCOSS.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/Modules/platforms/Gaea.cmake)
  site_name(HOSTNAME)
  message("The hostname is  ${HOSTNAME}" )
  string(REGEX MATCH "s4-" HOST-S4 ${HOSTNAME}  )
  string(REGEX MATCH "gaea" HOST-Gaea ${HOSTNAME}  )
  string(REGEX MATCH "tfe[0-9]" HOST-Theia ${HOSTNAME}  )
  if(EXISTS /jetmon) 
    set(HOST-Jet "True" )
  endif()
  string(REGEX MATCH "g[0-9][0-9]a" HOST-WCOSS ${HOSTNAME}  )
  if( HOST-WCOSS )
     message("host is WCOSS")
  endif()
  string(REGEX MATCH "g[0-9][0-9]a" HOST-WCOSS ${HOSTNAME}  )
  if( NOT HOST-WCOSS ) # don't overwrite if we are on gyre
    string(REGEX MATCH "t[0-9][0-9]a" HOST-WCOSS ${HOSTNAME}  )
  endif()
  string(REGEX MATCH "v[0-9][0-9]a" HOST-WCOSS_D ${HOSTNAME}  )
  if( NOT HOST-WCOSS_D )# don't overwrite if we are on venus
    string(REGEX MATCH "m[0-9][0-9]a" HOST-WCOSS_D ${HOSTNAME}  )
  endif()
  string(REGEX MATCH "llogin" HOST-WCOSS_C ${HOSTNAME}  )
  if( NOT HOST-WCOSS_C )# don't overwrite if we are on luna 
    string(REGEX MATCH "slogin" HOST-WCOSS_C ${HOSTNAME}  )
  endif()
  string(REGEX MATCH "discover" HOST-Discover ${HOSTNAME} )
  string(REGEX MATCH "cheyenne" HOST-Cheyenne ${HOSTNAME}  )
  message("done figuring out host--${HOSTNAME}")
  if ( BUILD_CORELIBS )
    MESSAGE(STATUS "BUILD_CORELIBS manually-specified as ON")
    set( host "GENERIC"  )
    set( HOST-Generic "TRUE"  )
    setGeneric()
  elseif(HOST-Jet)
    option(BUILD_CORELIBS "Build the Core libraries " OFF)
    set( host "Jet"  )
    set( HOST-Jet "TRUE"  )
    setJet()
  elseif( HOST-S4 ) 
    option(BUILD_CORELIBS "Build the Core libraries " ON)
    set( host "S4"  )
    set( HOST-S4 "TRUE"  )
    setS4()
  elseif( HOST-WCOSS )
    option(BUILD_CORELIBS "Build the Core libraries " OFF)
    set( host "WCOSS"  )
    set( HOST-WCOSS "TRUE"  )
    setWCOSS()
  elseif( HOST-Theia )
    set( host "Theia"  )
    option(BUILD_CORELIBS "Build the Core libraries " OFF)
    setTHEIA()
    set( HOST-Theia "TRUE"  )
  elseif( HOST-Gaea )
    set( host "Gaea"  )
    option(BUILD_CORELIBS "Build the Core libraries " On)
    setGaea()
    set( HOST-Gaea "TRUE"  )
  elseif( HOST-Cheyenne )
    option(BUILD_CORELIBS "Build the Core libraries " ON)
    set( host "Cheyenne"  )
    setCheyenne()
    set( HOST-Cheyenne "TRUE"  )
  elseif( HOST-WCOSS_C )
    set( host "WCOSS_C"  )
    option(BUILD_CORELIBS "Build the Core libraries " OFF)
    setWCOSS_C()
    set( HOST-WCOSS_C "TRUE"  )
  elseif( HOST-WCOSS_D )
    set( host "WCOSS_D"  ) 
    option(BUILD_CORELIBS "Build the Core libraries " OFF)
    setWCOSS_D()
    set( HOST-WCOSS_D "TRUE"  )
  elseif( HOST-Discover )
    set(host "Discover"  )
    setDiscover()
    set( HOST-Discover "TRUE"  )
  else(  )
    set( host "GENERIC" )
    option(BUILD_CORELIBS "Build the Core libraries " ON)
    setGeneric()
    set( HOST-Generic "TRUE"  )
  endif()
  message("Host is set to ${host}")
endmacro()
