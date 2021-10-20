cmake_minimum_required(VERSION 3.11) # FetchContent is available in 3.11+
project(example-carp)

# Set this to the minimal version you want to support
find_package(raylib 3.7 QUIET) # Let CMake search for a raylib-config.cmake

# You could change the QUIET above to REQUIRED and remove this if() clause
# This part downloads raylib and builds it if it's not installed on your system
if (NOT raylib_FOUND) # If there's none, fetch and build raylib
  include(FetchContent)

  FetchContent_Declare(
    raylib
    URL https://github.com/raysan5/raylib/archive/master.tar.gz
  )

  FetchContent_GetProperties(raylib)
  if (NOT raylib_POPULATED) # Have we downloaded raylib yet?
    set(FETCHCONTENT_QUIET NO)
    FetchContent_Populate(raylib)

    set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE) # don't build the supplied examples

    # build raylib
    add_subdirectory(${raylib_SOURCE_DIR} ${raylib_BINARY_DIR})

  endif()

endif()


add_compile_options(-D_CRT_SECURE_NO_WARNINGS)

include_directories($ENV{CARP_DIR}/core)

file(GLOB_RECURSE CARP_FILES ${PROJECT_SOURCE_DIR}/*.carp)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/carp-out/main.c
    COMMAND carp --no-core --generate-only -b ${CMAKE_CURRENT_SOURCE_DIR}/main.carp
    DEPENDS ${CARP_FILES}
)

add_executable(${PROJECT_NAME} ${CMAKE_CURRENT_BINARY_DIR}/carp-out/main.c)
#set(raylib_VERBOSE 1)
target_link_libraries(${PROJECT_NAME} raylib)

# Checks if OSX and links appropriate frameworks (Only required on MacOS)
if (APPLE)
    target_link_libraries(${PROJECT_NAME} "-framework IOKit")
    target_link_libraries(${PROJECT_NAME} "-framework Cocoa")
    target_link_libraries(${PROJECT_NAME} "-framework OpenGL")
endif()

