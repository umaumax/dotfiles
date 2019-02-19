#include <iostream>
#include <opencv2/core.hpp>

#define OPENCV_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))

int main() { std::cout << "version: " << CV_VERSION << std::endl; }

// g++ -std=c++11 $(pkg-config --libs opencv) $(pkg-config --cflags opencv) opencv_version_check.cpp
