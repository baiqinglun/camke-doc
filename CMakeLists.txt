cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

project(test
    VERSION         0.0.1
    DESCRIPTION     "Eglinux's cmake study test repo"
    HOMEPAGE_URL    "公众号: eglinux"
    LANGUAGES       CXX
)

list(APPEND CMAKE_MESSAGE_CONTEXT       "test")
list(APPEND CMAKE_MODULE_PATH           "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

add_subdirectory(src)