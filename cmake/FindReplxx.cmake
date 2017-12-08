# - Try to find Replxx Http library
# Once done this will define
#  REPLXX_FOUND - System has Replxx
#  Replxx::Replxx Imported target for Replxx

# handle the QUIETLY and REQUIRED arguments and
# set REPLXX_FOUND to TRUE
# if all listed variables are TRUE
include(FindPackageHandleStandardArgs)

### replxx ###
if (NOT REPLXX_FOUND)
   set(_PATHS)

   if (REPLXX_ROOT)
      set(_PATHS
         NO_DEFAULT_PATH
         PATHS ${REPLXX_ROOT}
         )
   endif(REPLXX_ROOT)

   find_path(REPLXX_INCLUDE_DIR "replxx.h"
             ${_PATHS}
             PATH_SUFFIXES "include")


   find_library(REPLXX_LIBRARY
                NAMES replxx libreplxx
                ${_PATHS}
                PATH_SUFFIXES "lib" "bin")

   find_package_handle_standard_args(REPLXX
      DEFAULT_MSG
      REPLXX_LIBRARY
      REPLXX_INCLUDE_DIR)

endif(NOT REPLXX_FOUND)

mark_as_advanced(REPLXX_INCLUDE_DIR REPLXX_LIBRARY)

if(REPLXX_FOUND)
  if(NOT TARGET Replxx::Replxx AND EXISTS "${REPLXX_LIBRARY}")
    add_library(Replxx::Replxx UNKNOWN IMPORTED)
    set_target_properties(Replxx::Replxx PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${REPLXX_INCLUDE_DIR}")
   set_target_properties(Replxx::Replxx PROPERTIES
      IMPORTED_LINK_INTERFACE_LANGUAGES "C"
      IMPORTED_LOCATION "${REPLXX_LIBRARY}")
  endif()
endif()
