#!/bin/sh
true + /; exec gawk -f "$0" "$@"; exit; / {}

BEGIN {
  debug_flag=debug
  print_flag=0
}

function block_start(){
  printf "{\n"
  printf "auto&& dump_tmp = XXX;\n"
}
function block_end(){
  printf "}\n"
}

match($0, /^( |\t)*class +([^ ]+)/, m) {
  class_name=m[1]
  if(debug_flag)printf "# class:%s\n", class_name
  private_access()

  if(print_flag==1) {
    block_end()
  }
  block_start()
  printf "std::cout << \"class %s\" << std::endl;\n", class_name

  print_flag=1
}
match($0, /^( |\t)*struct +([^ ]+)/, m) {
  struct_name=m[1]
  if(debug_flag)printf "# struct:%s\n", struct_name
  public_access()

  if(print_flag==1) {
    block_end()
  }
  block_start()
  printf "std::cout << \"struct %s\" << std::endl;\n", struct_name

  print_flag=1
}

match($0, /([:a-zA-Z0-9_]+) +([a-zA-Z0-9_]+).*;/, m) {
  type=m[1]
  name=m[2]
  if(debug_flag)printf "# type:%s, name:%s\n", type, name

  if(print_flag==0) {
    block_start()
    print_flag=1
  }
  printf "std::cout << \"%s = \"<< dump_tmp.%s << std::endl; // %s: %s\n", name, name, access_type,type
}

END{
  if(print_flag==1) {
    block_end()
  }
}

match($0, /private:/, m) {
  private_access()
}
match($0, /protected:/, m) {
  protected_access()
}
match($0, /public:/, m) {
  public_access()
}
function public_access() {
  if(debug_flag)printf "# public\n"
  access_type="public"
  access_public_flag=1
  access_protected_flag=0
  access_private_flag=0
}
function protected_access() {
  if(debug_flag)printf "# protected\n"
  access_type="protected"
  access_public_flag=0
  access_protected_flag=1
  access_private_flag=0
}
function private_access() {
  if(debug_flag)printf "# private\n"
  access_type="private"
  access_public_flag=0
  access_protected_flag=0
  access_private_flag=1
}
