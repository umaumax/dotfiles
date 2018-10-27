cmake_minimum_required(VERSION 2.8)
project(eigen-hello)

find_package(Eigen3 REQUIRED)
include_directories(${EIGEN3_INCLUDE_DIR})

add_executable(eigen-hello hello.cpp)

install(TARGETS eigen-hello DESTINATION bin)
