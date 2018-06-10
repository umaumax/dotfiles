clang++ main.cpp \
	$(llvm-config --cxxflags) \
	$(llvm-config --ldflags --libs --system-libs) \
	-lclang
