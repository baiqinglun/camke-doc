cmake_minimum_required(VERSION 3.25)

project(test
    VERSION         0.0.1
    DESCRIPTION     "Eglinux's cmake study test repo"
    HOMEPAGE_URL    "公众号: eglinux"
    LANGUAGES       CXX
)

list(APPEND CMAKE_MESSAGE_CONTEXT       "test")
list(APPEND CMAKE_MODULE_PATH           "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(IS_BUILD_TEST ON CACHE BOOL "is build test" FORCE)

add_subdirectory(src)