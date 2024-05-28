if (POLICY CMP0048)
    cmake_policy(SET CMP0048 NEW)
endif (POLICY CMP0048)

cmake_minimum_required(VERSION 3.20)

set(CMAKE_VERBOSE_MAKEFILE ON)

# Require out-of-source builds
file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

project(liblog LANGUAGES CXX)

include(FetchContent)

# Used as headers only library
FetchContent_Declare(libcutils-ndk
                     GIT_REPOSITORY https://github.com/MaDeG/libcutils-ndk.git
                     GIT_TAG master
                     GIT_SUBMODULES ""
                     SOURCE_SUBDIR .)
FetchContent_MakeAvailable(libcutils-ndk)
FetchContent_GetProperties(libcutils-ndk)

# Used as headers only library
FetchContent_Declare(libutils-ndk
                     GIT_REPOSITORY https://github.com/MaDeG/libutils-ndk.git
                     GIT_TAG master
                     GIT_SUBMODULES ""
                     SOURCE_SUBDIR .)
FetchContent_MakeAvailable(libutils-ndk)
FetchContent_GetProperties(libutils-ndk)

# Used as headers only library
FetchContent_Declare(libsystem-ndk
                     GIT_REPOSITORY https://github.com/MaDeG/libsystem-ndk.git
                     GIT_TAG master
                     GIT_SUBMODULES ""
                     SOURCE_SUBDIR .)
FetchContent_MakeAvailable(libsystem-ndk)
FetchContent_GetProperties(libsystem-ndk)

set(LIBLOG_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../)

set(ANDROID_SOURCES ${LIBLOG_ROOT}/android-base/errno_restorer.h
                    ${LIBLOG_ROOT}/android-base/file.cpp
                    ${LIBLOG_ROOT}/android-base/file.h
                    ${LIBLOG_ROOT}/android-base/log_main.h
                    ${LIBLOG_ROOT}/android-base/logging.h
                    ${LIBLOG_ROOT}/android-base/macros.h
                    ${LIBLOG_ROOT}/android-base/off64_t.h
                    ${LIBLOG_ROOT}/android-base/parseint.h
                    ${LIBLOG_ROOT}/android-base/stringprintf.cpp
                    ${LIBLOG_ROOT}/android-base/stringprintf.h
                    ${LIBLOG_ROOT}/android-base/strings.cpp
                    ${LIBLOG_ROOT}/android-base/strings.h
                    ${LIBLOG_ROOT}/android-base/threads.h
                    ${LIBLOG_ROOT}/android-base/unique_fd.h
                    ${LIBLOG_ROOT}/android-base/utf8.h
)

set(LIBLOG_SOURCES ${LIBLOG_ROOT}/log_event_list.cpp
                   ${LIBLOG_ROOT}/log_event_write.cpp
                   ${LIBLOG_ROOT}/logger_name.cpp
                   ${LIBLOG_ROOT}/logger_read.cpp
                   ${LIBLOG_ROOT}/logger_write.cpp
                   ${LIBLOG_ROOT}/logprint.cpp
                   ${LIBLOG_ROOT}/properties.cpp
                   ${LIBLOG_ROOT}/event_tag_map.cpp
                   ${LIBLOG_ROOT}/log_time.cpp
                   ${LIBLOG_ROOT}/pmsg_reader.cpp
                   ${LIBLOG_ROOT}/pmsg_writer.cpp
                   ${LIBLOG_ROOT}/logd_reader.cpp
                   ${LIBLOG_ROOT}/logd_writer.cpp
)

# Target name is not log in order to avoid confusion with the NDK integrated one
add_library(log-ndk STATIC ${ANDROID_SOURCES} ${LIBLOG_SOURCES})
target_include_directories(log-ndk PUBLIC ${LIBLOG_ROOT}/include)
target_include_directories(log-ndk PRIVATE ${LIBLOG_ROOT}
                                           ${libcutils-ndk_SOURCE_DIR}/include
                                           ${libutils-ndk_SOURCE_DIR}/include
                                           ${libsystem-ndk_SOURCE_DIR}/include
)
target_compile_definitions(log-ndk PUBLIC ANDROID_DEBUGGABLE=1
                                          SNET_EVENT_LOG_TAG=1397638484
                                          LIBLOG_LOG_TAG=1006
)

set_property(TARGET log-ndk PROPERTY CXX_STANDARD 20)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(log-ndk PRIVATE $<BUILD_INTERFACE:-Wno-unknown-attributes>)
endif()