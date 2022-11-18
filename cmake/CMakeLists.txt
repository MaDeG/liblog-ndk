#TODO: Switch to the more Conan 2.0 compliant Python way of operating it

cmake_minimum_required(VERSION 3.10)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    include("./CMakeListsConan.txt")
endif()

project(liblog LANGUAGES CXX)

include(FetchContent)

FetchContent_Declare(libcutils-ndk
                     GIT_REPOSITORY git@github.com:MaDeG/libcutils-ndk.git
                     GIT_TAG master
                     GIT_SUBMODULES ""
                     SOURCE_SUBDIR .)
FetchContent_MakeAvailable(libcutils-ndk)
FetchContent_GetProperties(libcutils-ndk)

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
)

# Target name is not liblog in order to avoid confusion with the NDK integrated one
add_library(liblog-ndk STATIC ${ANDROID_SOURCES} ${LIBLOG_SOURCES})
target_include_directories(liblog-ndk PUBLIC ${LIBLOG_ROOT}/include)
target_include_directories(liblog-ndk PRIVATE ${LIBLOG_ROOT} ${libcutils-ndk_SOURCE_DIR}/include)

set_property(TARGET liblog-ndk PROPERTY CXX_STANDARD 20)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(liblog-ndk PRIVATE $<BUILD_INTERFACE:-Wno-unknown-attributes>)
endif()