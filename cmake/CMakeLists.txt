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

set(ANDROID_SOURCES ${LIBZIPARCHIVE_ROOT}/android-base/errno_restorer.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/file.cpp
                    ${LIBZIPARCHIVE_ROOT}/android-base/file.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/log_main.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/logging.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/macros.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/off64_t.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/parseint.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/stringprintf.cpp
                    ${LIBZIPARCHIVE_ROOT}/android-base/stringprintf.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/strings.cpp
                    ${LIBZIPARCHIVE_ROOT}/android-base/strings.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/threads.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/unique_fd.h
                    ${LIBZIPARCHIVE_ROOT}/android-base/utf8.h
)

set(LIBLOG_SOURCES ${LIBLOG_ROOT}/log_event_list.cpp
                   ${LIBLOG_ROOT}/log_event_write.cpp
                   ${LIBLOG_ROOT}/logger_name.cpp
                   ${LIBLOG_ROOT}/logger_read.cpp
                   ${LIBLOG_ROOT}/logger_write.cpp
                   ${LIBLOG_ROOT}/logprint.cpp
                   ${LIBLOG_ROOT}/properties.cpp
)

add_library(liblog STATIC ${ANDROID_SOURCES} ${LIBLOG_SOURCES})
target_include_directories(liblog PUBLIC ${LIBLOG_ROOT}/include)
target_include_directories(liblog PRIVATE ${LIBLOG_ROOT} ${libcutils-ndk_SOURCE_DIR}/include)
target_link_libraries(liblog log)

set_property(TARGET liblog PROPERTY CXX_STANDARD 20)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(liblog PRIVATE $<BUILD_INTERFACE:-Wno-unknown-attributes>)
endif()