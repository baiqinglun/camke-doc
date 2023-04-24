# CMake-doc

## 1、搭建cmake项目目录

### 1.1 目录预览

![image-20230425004143019](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230425004143019.png)

--cmake（cmake目录模板）

--docs（文档）

--example（示例）

--external（第三方库）

--include（包含的头文件）

--packaging（打包文件）

--src（源文件）

​	--math（数学库）

​		--CMakeLists.txt

​	--zip（压缩库）

​		--CMakeLists.txt

--test

​	--CMakeLists.txt

--.gitignore

--CMakeLists.txt

--lLICENSE

--README.md

### 1.2 最外层CMakeLists

```cmake
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
```

### 1.3 src下的CMakeLists

math下

```cmake
cmake_minimum_required(VERSION 3.25 FATAL_ERROE)

add_library(math math.cpp) // 生成library
```

src下

```cmake
cmake_minimum_required(VERSION 3.25 FATAL_ERROE)

add_subdirectory(math) // 添加子库

add_executable(cmake cmake.cpp) // 生成可执行文件
```

## 2、运行cmake项目

### 2.1 src文件夹

src/cmake.cpp

```c++
#include<iostream>

int main(int argc,const char* argv[]){
    
    std::cout << "hello world!" << std::endl;

    return 0;
}
```

src/CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.25)

add_subdirectory(math)

add_executable(main cmake.cpp)
add_executable(main2 cmake.cpp)
```

执行

![image-20230425012231555](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230425012231555.png)



![image-20230425012324981](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230425012324981.png)

### 2.2 调试

![image-20230425012511410](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230425012511410.png)