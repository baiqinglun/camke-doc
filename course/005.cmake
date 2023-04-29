# cmake环境变量

# 此文件后缀是cmake的脚本文件，可通过一下命令在命令行中执行
# cmake -P .\005.cmake

# 获取系统变量
message(STATUS "PATH=$ENV{PATH}")
message("PATH=$ENV{PATH}")

# 定义环境变量
set(ENV{GIT_PATH} "/user/bin")
message(STATUS "GIT_PATH=$ENV{GIT_PATH}")