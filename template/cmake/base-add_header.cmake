# this function compiles header files as symbolic cpp files
# ===> you can adopt clang-tidy by -DCMAKE_CXX_CLANG_TIDY="clang-tidy;-checks=*" (cmake >=3.6) or use compile_commands.json
function(add_header_filepath header_filepath)
  set(target ${header_filepath}_target)
  string(REPLACE "/"
                 "_"
                 target
                 ${target})
  set(dummy_cpp_symbolic_link_filepath ${header_filepath}.cpp)
  add_library(${target} ${dummy_cpp_symbolic_link_filepath})
  set_target_properties(${target}
                        PROPERTIES SOURCES ${dummy_cpp_symbolic_link_filepath})
  get_filename_component(header_dirpath ${header_filepath} DIRECTORY)
  add_custom_command(OUTPUT ${dummy_cpp_symbolic_link_filepath}
                     COMMAND "mkdir" "-p" "${header_dirpath}"
                     COMMAND "ln" "-sf"
                             "${CMAKE_CURRENT_SOURCE_DIR}/${header_filepath}"
                             "${dummy_cpp_symbolic_link_filepath}")
endfunction()

function(add_header_dirpath header_dirpath)
  file(GLOB_RECURSE header_filepath_list
       RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${header_dirpath}/*.hpp)
  foreach(header_filepath IN LISTS header_filepath_list)
    add_header_filepath(${header_filepath})
  endforeach()
endfunction()
