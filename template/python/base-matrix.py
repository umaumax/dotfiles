#!/usr/bin/env python3
import numpy as np

# (2,3)
# 1,2,3
# 4,5,6
a = np.array([[1, 2, 3], [4, 5, 6]])
b = np.array([[1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]])
c = np.dot(a, b)
print("c")
print(c)
print("a")
print(a)
print("b")
print(b)
