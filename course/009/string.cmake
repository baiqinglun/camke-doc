cmake_minimum_required(VERSION 3.25)

string(FIND "abcdefgbcd" "bcd" fwdIndex)
string(FIND "abcdefgbcd" "bcd" revIndex REVERSE)
# fwdIndex=1
# revIndex=7
message("fwdIndex=${fwdIndex}\nrevIndex=${revIndex}")
message("-------------------------------")

string(REPLACE "abc" "cdd" outString abc-abc-abc)
message("outString=${outString}")
message("-------------------------------")

set(my_string "Hello, World!")
message("my_string=${my_string}")

string(LENGTH ${my_string} string_length)
message("string_length=${string_length}")

string(SUBSTRING ${my_string} 0 5 substring)
message("substring=${substring}")

string(REPLACE "Hello" "Goodbye" my_new_string ${my_string})
message("my_new_string=${my_new_string}")

string(TOUPPER ${my_string} upper_case)
message("upper_case=${upper_case}")

string(TOLOWER ${my_string} lower_case)
message("lower_case=${lower_case}")
