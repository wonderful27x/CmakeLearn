# messageConfig.cmake
# ---------------------
#
# message cmake module.
# This module sets the following variables in your project:
#
# ::
#
#   message_FOUND - true if message found on the system
#   message_VERSION - message version in format Major.Minor.Release
#
#
# Exported targets:
#
# ::
#
# If message is found, this module defines the following :prop_tgt:`IMPORTED`
# targets. ::
#   message::message-shared - the main message shared library with header & defs attached.
#   message::message-static - the main message static library with header & defs attached.
#   message::hello-world_wDSO - the hello-world program for the message, linked
#                               against the dynamic shared object.
#   message::hello-world_wAR - the hello-world program for the message, linked
#                               against the static archive.
#
#
# Suggested usage:
#
# ::
#
#   find_package(message)
#   find_package(message 1.1.7 CONFIG REQUIRED)
#
#
# The following variables can be set to guide the search for this package:
#
# ::
#
#   message_DIR - CMake variable, set to directory containing this Config file
#   CMAKE_PREFIX_PATH - CMake variable, set to root directory of this package
#   PATH - environment variable, set to bin directory of this package
#   CMAKE_DISABLE_FIND_PACKAGE_message - CMake variable, disables
#       find_package(message) perhaps to force internal build


####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was messageConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

macro(set_and_check _var _file)
  set(${_var} "${_file}")
  if(NOT EXISTS "${_file}")
    message(FATAL_ERROR "File or directory ${_file} referenced by variable ${_var} does not exist !")
  endif()
endmacro()

macro(check_required_components _NAME)
  foreach(comp ${${_NAME}_FIND_COMPONENTS})
    if(NOT ${_NAME}_${comp}_FOUND)
      if(${_NAME}_FIND_REQUIRED_${comp})
        set(${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()

####################################################################################

include("${CMAKE_CURRENT_LIST_DIR}/messageTargets.cmake")
check_required_components(
  "message-shared"
  "message-static"
  "message-hello-world_wDSO"
  "message-hello-world_wAR"
  )

# Remove dependency on UUID if on Windows
if(NOT WIN32)
  if(NOT TARGET PkgConfig::UUID)
    find_package(PkgConfig REQUIRED QUIET)
    pkg_search_module(UUID REQUIRED uuid IMPORTED_TARGET)
  endif()
endif()
