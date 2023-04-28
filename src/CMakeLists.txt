cmake_minimum_required(VERSION 3.25)

add_subdirectory(math)
add_executable(main cmake.cpp)

target_link_libraries(main PRIVATE math)
