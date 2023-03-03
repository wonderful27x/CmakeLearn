#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "message::message-shared" for configuration "Release"
set_property(TARGET message::message-shared APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(message::message-shared PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmessage.so.1"
  IMPORTED_SONAME_RELEASE "libmessage.so.1"
  )

list(APPEND _IMPORT_CHECK_TARGETS message::message-shared )
list(APPEND _IMPORT_CHECK_FILES_FOR_message::message-shared "${_IMPORT_PREFIX}/lib/libmessage.so.1" )

# Import target "message::message-static" for configuration "Release"
set_property(TARGET message::message-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(message::message-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmessage_s.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS message::message-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_message::message-static "${_IMPORT_PREFIX}/lib/libmessage_s.a" )

# Import target "message::hello-world_wDSO" for configuration "Release"
set_property(TARGET message::hello-world_wDSO APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(message::hello-world_wDSO PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/hello-world_wDSO"
  )

list(APPEND _IMPORT_CHECK_TARGETS message::hello-world_wDSO )
list(APPEND _IMPORT_CHECK_FILES_FOR_message::hello-world_wDSO "${_IMPORT_PREFIX}/bin/hello-world_wDSO" )

# Import target "message::hello-world_wAR" for configuration "Release"
set_property(TARGET message::hello-world_wAR APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(message::hello-world_wAR PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/hello-world_wAR"
  )

list(APPEND _IMPORT_CHECK_TARGETS message::hello-world_wAR )
list(APPEND _IMPORT_CHECK_FILES_FOR_message::hello-world_wAR "${_IMPORT_PREFIX}/bin/hello-world_wAR" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
