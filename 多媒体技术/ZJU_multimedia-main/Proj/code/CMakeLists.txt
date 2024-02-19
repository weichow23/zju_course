cmake_minimum_required(VERSION 3.24)
project(Proj)

set(CMAKE_CXX_STANDARD 17)

find_package(OpenCV)
include_directories(${OpenCV_INCLUDE_DIRS})

add_executable(encode2708 encode2708.cpp)
target_link_libraries(encode2708 ${OpenCV_LIBS})

add_executable(decode2708 decode2708.cpp)
target_link_libraries(decode2708 ${OpenCV_LIBS})