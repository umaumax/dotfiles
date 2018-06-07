# save this file as 'DoClangTidy.cmake' and write below at CMakeLists.txt
# include(DoClangTidy.cmake)
# ...
# clang_tidy(${target})
cmake_minimum_required(VERSION 3.6)
option(CLANG_TIDY_ENABLE
	"If the command clang-tidy is avilable, tidy source files.\
Turn this off if the build time is too slow."
	ON)
find_program(CLANG_TIDY_EXE clang-tidy)

function(clang_tidy target)
	if(CLANG_TIDY_EXE)
		if(CLANG_TIDY_ENABLE)
			message(STATUS "Enable Clang-Tidy ${target}")
			set_target_properties(${target} PROPERTIES
				C_CLANG_TIDY "${CLANG_TIDY_EXE};-fix;-fix-errors"
				CXX_CLANG_TIDY "${CLANG_TIDY_EXE};-fix;-fix-errors")
			endif()
	endif()
endfunction()
