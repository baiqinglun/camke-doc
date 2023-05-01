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

## 8、CMake 变量总结

通过前面三讲关于 CMake 变量的学习，我们已经对变量的基础知识非常熟悉了，本讲我们对 CMake 变量做一个总结。把一些 CMake 变量的异常行为做一个说明。

首先我们来看看普通变量和缓存变量同名会发生什么呢？

- 如果使用 option() 命令设置缓存变量之前已经存在同名的普通变量了，会发生什么？反之呢？
- 如果使用 set() 命令设置缓存变量之前已经存在同名的普通变量了，会发生什么呢？反之呢？存在 INTERNAL 或者 FORCE 关键字呢？

接着我们辨析一下如下 CMake 代码：

```cmake
unset(foo)
set(foo)
set(foo "")
```

- 如果要将一个变量的值设置为空字符串，请使用第三行的方式。

除了在 CMakeLists.txt 中定义缓存变量，我们还有其他方式定义缓存变量吗？

```shell
cmake -D myVar:type=someValue ...
```

- 使用上述 cmake 命令 -D 的方式定义缓存变量，只需要第一次运行时指定就行了，如果每次都指定，该缓存变量的值也每次都会更新。
- 可以使用多个 -D 指定多个缓存变量
- 如果 -D 设置一个忽略类型的缓存变量，在 CMakeLists.txt 中也定义了一个同名的缓存变量，并指定类型为 FILEPATH 或者 PATH，那从不同的目录运行 cmake 会有什么不同？

我们可以使用 cmake 命令 -D 的方式定义缓存变量，那有没有类似方式取消缓存变量的定义呢？

```shell
cmake -U 'help*' -U foo ...
```

- 支持通配符 * 和 ?

我们再来通过 CMake 图形化界面工具加深对 CMake 变量的理解：

- cmake-gui
- ccmake
- 高级变量
  ```cmake
  mark_as_advanced([CLEAR|FORCE] var1 [var2...])
  ```
  - CLEAR：不标记为高级变量
  - FORCE：标记为高级变量
  - 如果这两个关键字都没有，那只有在该变量从未标记过高级变量或非高级变量时才将其标记为高级变量
- Grouped 选项，前缀相同的变量组合在一起

最后我们看看如何打印变量的值。

```cmake
set(myVar HiThere)
message("The value of myVar = ${myVar}\nAnd this "
"appears on the next line")
```

- message() 命令，后续会详细讲解其用法，本讲只需要会简单的使用即可。

## 9、[CMake字符串](https://cmake.org/cmake/help/latest/command/string.html)

使用字符串功能来处理文本字符串

```cmake
Search and Replace
  string(FIND <string> <substring> <out-var> [...])
  string(REPLACE <match-string> <replace-string> <out-var> <input>...)
  string(REGEX MATCH <match-regex> <out-var> <input>...)
  string(REGEX MATCHALL <match-regex> <out-var> <input>...)
  string(REGEX REPLACE <match-regex> <replace-expr> <out-var> <input>...)

Manipulation
  string(APPEND <string-var> [<input>...])
  string(PREPEND <string-var> [<input>...])
  string(CONCAT <out-var> [<input>...])
  string(JOIN <glue> <out-var> [<input>...])
  string(TOLOWER <string> <out-var>)
  string(TOUPPER <string> <out-var>)
  string(LENGTH <string> <out-var>)
  string(SUBSTRING <string> <begin> <length> <out-var>)
  string(STRIP <string> <out-var>)
  string(GENEX_STRIP <string> <out-var>)
  string(REPEAT <string> <count> <out-var>)

Comparison
  string(COMPARE <op> <string1> <string2> <out-var>)

Hashing
  string(<HASH> <out-var> <input>)

Generation
  string(ASCII <number>... <out-var>)
  string(HEX <string> <out-var>)
  string(CONFIGURE <string> <out-var> [...])
  string(MAKE_C_IDENTIFIER <string> <out-var>)
  string(RANDOM [<option>...] <out-var>)
  string(TIMESTAMP <out-var> [<format string>] [UTC])
  string(UUID <out-var> ...)

JSON
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         {GET | TYPE | LENGTH | REMOVE}
         <json-string> <member|index> [<member|index> ...])
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         MEMBER <json-string>
         [<member|index> ...] <index>)
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         SET <json-string>
         <member|index> [<member|index> ...] <value>)
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         EQUAL <json-string1> <json-string2>)
```



### 9.1 字符串查找

- 在 inputString 中查找 subString，将查找到的索引存在 outVar 中，索引从 0 开始。
- 如果没有 REVERSE 选项，则保存第一个查找到的索引，否则保存最后一个查找到的索引。
- 如果没有找到则保存 -1。

需要注意的是，string(FIND) 将所有字符串都作为 ASCII 字符，outVar 中存储的索引也会以字节为单位计算，因此包含多字节字符的字符串可能会导致意想不到的结果。

```cmake
string(FIND "abcdefgbcd" "bcd" fwdIndex)
string(FIND "abcdefgbcd" "bcd" revIndex REVERSE)
# fwdIndex=1
# revIndex=7
message("fwdIndex=${fwdIndex}\nrevIndex=${revIndex}")
```

![image-20230501163613287](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230501163613287.png)

### 9.2 字符串替换

- 将 input 中所有匹配 matchString 的都用 replaceWith 替换，并将结果保存到 outVar 中。
- 如果有多个 input，它们是直接连接在一起的，没有任何分隔符。
  - 这有时可能会有问题，所以通常建议只提供一个 input 字符串。

```cmake
string(REPLACE "abc" "cdd" outString abc-abc-abc)
message("outString=${outString}")
```

![image-20230501163620674](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230501163620674.png)

还可以使用正则表达式（cmake自定义正则表达式）查找

### 9.3 其他操作

1. `string(LENGTH <string> <output variable>)` - 获取字符串的长度并将其存储到输出变量中。
2. `string(SUBSTRING <string> <offset> <length> <output variable>)` - 从字符串中提取一个子字符串，并将其存储在输出变量中。
3. `string(REPLACE <match string> <replace string> <output variable> <input string>)` - 在输入字符串中查找匹配字符串，并将其替换为替换字符串。
4. `string(TOUPPER <input string> <output variable>)` - 将输入字符串转换为大写，并将其存储在输出变量中。
5. `string(TOLOWER <input string> <output variable>)` - 将输入字符串转换为小写，并将其存储在输出变量中。

代码演示

```cmake
set(my_string "Hello, World!")
string(LENGTH ${my_string} string_length)
string(SUBSTRING ${my_string} 0 5 substring)
string(REPLACE "Hello" "Goodbye" \ my_new_string ${my_string})
string(TOUPPER ${my_string} upper_case)
string(TOLOWER ${my_string} lower_case)
```

![image-20230501164736996](https://test-123456-md-images.oss-cn-beijing.aliyuncs.com/img/image-20230501164736996.png)

























