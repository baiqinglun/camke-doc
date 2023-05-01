cmake_minimum_required(VERSION 3.25)

project(test8)

option(IS_SHOW "is show" ON)
option(IS_BEAUTY "is beauty" OFF)

set(TEMP_PATH "/tmp" CACHE PATH "temp path")
message(STATUS "TEMP_PATH=${TEMP_PATH}")