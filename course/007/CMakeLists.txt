cmake_minimum_required(VERSION 3.25)

project(test)

add_subdirectory(sub)

function(test007)
    set(B "bbb")
    message(STATUS "test007 A=${A}")
    message(STATUS "test007 B=${B}")
endfunction(test007)

test007()

message(STATUS "top A=${A}")
message(STATUS "top B=${B}")

# set(x 1)
# block()
#     set(x 2)
#     set(y 3)
#     message(STATUS "x=${x}")
#     message(STATUS "y=${y}")
# endblock()

# message(STATUS "top x=${x}")
# message(STATUS "top y=${y}")

# set(x 1)
# set(y 3)
# block()
#     set(x 2 PARENT_SCOPE)
#     unset(y PARENT_SCOPE)
#     message(STATUS "x=${x}")
#     message(STATUS "y=${y}")
# endblock()

# message(STATUS "top x=${x}")
# message(STATUS "top y=${y}")

set(x 1)
set(z 5)
block(PROPAGATE x z)
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