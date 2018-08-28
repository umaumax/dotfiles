cmake_minimum_required(VERSION 2.8)
project(CMakeHelloWorld)

#version number
set(CMakeHelloWorld_VERSION_MAJOR 1)
set(CMakeHelloWorld_VERSION_MINOR 0)

#include the subdirectory containing our libs
add_subdirectory(Hello)

add_definitions(-DFOO)
include_directories(Hello)
link_directories(/path1/to/lib /path2/to/lib)
#indicate the entry point for the executable
add_executable(CMakeHelloWorld Hello HelloWorld.cpp)

# Indicate which libraries to include during the link process.
target_link_libraries(CMakeHelloWorld Hello)

install(TARGETS CMakeHelloWorld DESTINATION bin)
