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
# FATAL_ERROE：表示如果版本小于3.25报致命错误
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

## 3、CMake Targets

### 3.1 构建简单的Targets

CMake有3个基本命令，用于定义target，分别为

1. add_executable()
2. add_library()
3. add_custom_target()

### 3.2 [add_executable](https://cmake.org/cmake/help/latest/command/add_executable.html)

定义一个可以构建成可执行程序的 Target。

```cmake
add_executable(<name> [WIN32] [MACOSX_BUNDLE]
               [EXCLUDE_FROM_ALL]
               [source1] [source2 ...])
```

第一个参数是 Target 的名字，这个参数必须提供。

第二个参数 WIN32 是可选参数，Windows 平台特定的参数。

第三个参数 MACOSX_BUNDLE 同第二个参数，是 Apple 平台的特定参数。

第四个参数 EXCLUDE_FROM_ALL 如果存在，那 CMake 默认构建的时候就不会构建这个 Target。

### 3.3 [add_library](https://cmake.org/cmake/help/latest/command/add_library.html)

定义构建成库文件的 Target。(编写库)

```cmake
add_library(<name> [STATIC | SHARED | MODULE]
            [EXCLUDE_FROM_ALL]
            [<source>...])
```

add_library() 命令支持可选的三个互斥参数：STATIC | SHARED | MODULE。默认为STATIC。

> 这里要注意，动态库需要在exe所在的目录下才能调用，否则调用不成功。

STATIC（静态库）、SHARED（动态库）、MODULE（类似于动态库，不过不会被其他库或者可执行程序链接，用于插件式框架的软件的插件构建）

两种用法（区别在于在哪添加源码）

第一种：

```cmake
cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

add_library(math SHARED math.cpp)
```

第二种：

```cmake
cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

add_library(math)

target_sources(math
    PRIVATE
        add.cpp
)
```

### 3.4 [add_cystom_target](https://cmake.org/cmake/help/latest/command/add_custom_target.html)

基本用不到，属于高级用法。

```cmake
add_custom_target(Name [ALL] [command1 [args1...]]
                  [COMMAND command2 [args2...] ...]
                  [DEPENDS depend depend depend ... ]
                  [BYPRODUCTS [files...]]
                  [WORKING_DIRECTORY dir]
                  [COMMENT comment]
                  [JOB_POOL job_pool]
                  [VERBATIM] [USES_TERMINAL]
                  [COMMAND_EXPAND_LISTS]
                  [SOURCES src1 [src2...]])
```

### 3.5 target链接(target_link_library())

```cmake
target_link_libraries(targetName
    <PRIVATE|PUBLIC|INTERFACE> item1 [item2 ...]
    [<PRIVATE|PUBLIC|INTERFACE> item3 [item4 ...]]
    ...
)
```

第一个参数必须指定，该名字必须是一个由 add_executable() 或者 add_library() 命令创建的 Target 的名字。

后续可以接多个 PRIVATE、PUBLIC、INTERFACE 选项，这三个选项类似于 C++ 类定义中的 PUBLIC、PRIVATE、PROTECT。

这三个选项后面跟着的 iterms 一般是一些库的名字，这些库可以是由 add_library() 命令创建的 Target 的名字，也可以是其他方式引入的库的名字。

PRIVATE 选项的含义是：targetName 这个 target 会链接 PRIVATE 选项后的 iterms 指定的这些库，这些库只有 targetName 这个 Target 本身需要，其他任何链接 targetName 这个 Target 的其他 Target 都不知道这些 iterms 的存在。

PUBLIC 选项的含义是：不止 targetName 本身这个 Target 需要这些 iterms，其他链接到 targetName 的 Target 也需要依赖这些 iterms，并链接这些 iterms。

INTERFACE 选项的含义是：targetName 本身不需要这些 iterms，但是其他链接 targetName 的 Target 需要依赖这些 iterms，并链接这些 iterms。

```cmake
cmake_minimum_required(VERSION 3.25)

add_subdirectory(math)

add_executable(main cmake.cpp)

target_link_libraries(main PRIVATE math)
```

> target_link_libraries一定要指定PRIVATE | PUBLIC | INTERFACE

## 4、CMake变量之普通变量

```cmake
set(varName value... [PARENT_SCOPE])
```

第一个参数是必须的，代表要定义的变量的变量名。

第二个参数也是必须的，代表要定义的变量的值。

第三个参数是一个可选参数，意思是定义的这个变量的作用域属于父作用域，关于作用域我们后面也会详细讲解，本讲大家不要使用这个可选参数即可。

CMake 变量的约定：

1. CMake 将所有的变量的值视为字符串
2. 当给出变量的值不包含空格的时候，可以不使用引号，但建议都加上引号，不然一些奇怪的问题很难调试。
3. CMake 使用空格或者分号作为字符串的分隔符
4. CMake 中采用 ${var} 形式获取变量的值
5. 如果使用了未定义的变量，那么它的值是一个空字符串。
6. 默认情况下使用未定义的变量不会有警告信息，但是可以通过cmake 的 -warn-uninitialized 选项启用警告信息。
7. 变量的值可以包含换行，也可以包含引号，不过需要转义。

代码示例

```cmake
set(CPR_TOP_DIR "/root/workspace/code/cpr")

set(CPR_BASE_SOURCE "a.cpp;b.cpp")

set(CPR_CORE_SOURCE core1.cpp core2.cpp)

# 设置能换行，使用两个中括号
set(CPR_BUILD_CMD [[
#!/bin/bash

cmake -S . -B build
cmake --build build
]])

# 如果中括号内要使用中括号，则在中括号之间加=或者其他字符
set(shellScript [=[
#!/bin/bash
[[ -n "${USER}" ]] && echo "Have USER"
]=])
```

取消定义变量

```cmake
unset(CPR_TOP_DIR)
```

## 5、CMake变量之环境变量

cmake的环境变量不会影响系统的环境变量，但可以和系统的环境变量交互。

```cmake
# 此文件后缀是cmake的脚本文件，可通过一下命令在命令行中执行
# cmake -P .\005.cmake

# 获取系统变量
message(STATUS "PATH=$ENV{PATH}")
message("PATH=$ENV{PATH}")

# 定义环境变量
set(ENV{GIT_PATH} "/user/bin")
message(STATUS "GIT_PATH=$ENV{GIT_PATH}")
```

## 6、CMake变量之缓存变量

1. 缓存变量可以缓存到CMakeCache.txt中，缓存变量的作用于是全局的。
2. 和普通变量相比，缓存变量可以存储值的类型

```cmake
set(<variable> <value>... CACHE <type> <docstring> [FORCE])
```

1. 第一个变量：变量名；
2. 第二个变量：变量值；
3. 第三个变量：固定的CMAKE关键字（表示定义的是缓存变量）；
4. 第四个变量：必选参数type类型；
5. 第五个变量：描述信息；

### 6.1 type类型

1. BOOL：BOOL 类型的变量值如果是 ON、TRUE、1 则被评估为真，如果是 OFF、FALSE、0 则被评估为假
2. FILEPATH：文件路径
3. PATH：文件夹路径
4. STRING：字符串
5. INTERNAL：内部缓存变量不会对用户可见，一般是项目为了缓存某种内部信息时才使用。内部缓存变量默认是 FORCE 的。FORCE 关键字代表每次运行都强制更新缓存变量的值，如果没有该关键字，当再次运行 cmake 的时候，cmake 将使用 CMakeCache.txt 文件中缓存的值，而不是重新进行评估。

### 6.2 option

由于BOOL类型的缓存变量使用频率高，所以cmake单独定义一个函数（option）来定义BOOL缓存变量

```cmake
option(<variable> "<help_text>" [value])
```

第一个参数是变量的名字，第二个参数是提供帮助信息的字符串，可以为空字符串。 initialValue 是可选参数，代表缓存变量的值，如果没有提供，那该缓存变量的值默认为 OFF。

```cmake
option(optVar helpString [initialValue])
set(optVar initialValue CACHE BOOL helpString)
```

两者等价

### 6.3 CMakeCache中缓存变量

普通变量适用于变量的值相对固定，而且只在某一个很小的作用域生效的场景。

缓存变量适用于其值可以随时更改，作用域为全局的情况。经常在 CMake 中定义缓存变量，给一个默认值，如果用户想要更改缓存变量的值，可以通过 cmake -D 的形式去更改。

比如我们这里定义个IS_BUILD_TEST缓存变量，如果后面不加FORCE，则只能通过 cmake -D形式区更改

```cmake
set(IS_BUILD_TEST ON CACHE BOOL "is build test" FORCE)
```

在CMakeCache.txt文件中输出

![输出](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/20230429195324.png)

## 7、CMake变量之作用域

- CMake中使用add_subdirectory()或定义一个函数都可以产生新的作用域，3.25版本开始，可以使用block()在任何位置产生新的作用域。
- 在定义普通变量时，如果没有PARENT_SCOPE选项，该变量的作用域就在当前的CMakeLists.txt中或者当前的函数，或者当前的block中。

### 7.1 add_subdirectory作用域

构建命令

```cmake
cmake -S . -B build
```

目录结构

![image-20230429201215529](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230429201215529.png)

`sub/CMakeLists.txt`中的A没有使用PARENT_SCOPE情况

```cmake
# sub/CMakeLists.txt
cmake_minimum_required(VERSION 3.25)

set(A "aaa")

message(STATUS "sub A=${A}")
```

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.25)

project(test)

add_subdirectory(sub)

message(STATUS "top A=${A}")
```

![image-20230429201354557](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230429201354557.png)

top中打印不出来



`sub/CMakeLists.txt`中的A使用PARENT_SCOPE情况

```cmake
cmake_minimum_required(VERSION 3.25)

set(A "aaa" PARENT_SCOPE)

message(STATUS "sub A=${A}")
```

![image-20230429201434223](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230429201434223.png)



### 7.2 函数产生的作用域

```cmake
function(test007)
    set(B "bbb")
    message(STATUS "test007 A=${A}")
    message(STATUS "test007 B=${B}")
endfunction(test007)

test007()

message(STATUS "top A=${A}")
message(STATUS "top B=${B}")
```

![image-20230429202217822](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230429202217822.png)

这里的作用域效果和c++语言一样，函数内部的可以访问外部的，外部的访问不了函数内部的。

> 这里需要注意别忘记调用函数

### 7.3 block产生的作用域

需要cmake版本大于3.25

示例1：

```cmake
set(x 1)
block()
    set(x 2)
    set(y 3)
    message(STATUS "x=${x}")
    message(STATUS "y=${y}")
endblock()

message(STATUS "top x=${x}")
message(STATUS "top y=${y}")
```

![image-20230429202705389](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230429202705389.png)

内部的变量和外部不冲突

示例2：

```cmake
set(x 1)
set(y 3)
block()
    # 这里出了作用域才生效
    set(x 2 PARENT_SCOPE)
    unset(y PARENT_SCOPE)
    message(STATUS "x=${x}") # 所以这里打印的还是x=1
    message(STATUS "y=${y}") # 这时y还没有被取消设置，y=3
endblock()

message(STATUS "top x=${x}")
message(STATUS "top y=${y}")
```

![image-20230429203055300](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230429203055300.png)

示例3：

```cmake
set(x 1)
set(z 5)
block(PROPAGATE x z) # 立即生效
    set(x 2)
    set(y 3)
    unset(z)
    message(STATUS "x=${x}")
    message(STATUS "y=${y}")
    message(STATUS "z=${z}")
endblock()

message(STATUS "top x=${x}")
message(STATUS "top y=${y}")
message(STATUS "top z=${z}")
```

![image-20230429203556568](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230429203556568.png)