cmake_minimum_required(VERSION 3.25 FATAL_ERROE)

project(cmake
    PROJECT_VERSION 0.0.1
    PROJECT_DESCRIPTION "cmake demo"
    PROJECT_HOMEPAGE_URL "https://github.com/baiqinglun/camke-doc"
    LANGUAGE C CXX
)

# 具备的参数
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(Buildinfo)

# 添加子项目
add_subdirectory(external)
add_subdirectory(src)
add_subdirectory(docs)
add_subdirectory(test)
add_subdirectory(packaging)