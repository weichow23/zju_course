cmake_minimum_required(VERSION 3.25)

project(Server)
set(CMAKE_CXX_STANDARD 17)

add_executable(Server
        main.cpp
        server.h
        utils.cpp
        utils.h
        server.cpp utils.cpp)
target_link_libraries(Server PRIVATE ws2_32)
