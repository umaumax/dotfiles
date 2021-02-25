# cpp header info

## how to run script
`./gen_header_data.sh` creates `c++11-headers.txt` from `c++11-headers.raw.txt`

### at linux
``` bash
{ cat /usr/include/fcntl.h | grep extern | grep -v '__REDIRECT' | awk '{ print $3; }'; cat /usr/include/x86_64-linux-gnu/bits/fcntl-linux.h | grep -E -o '\bO_\w+'; } | sort | uniq | perl -pe "chomp if eof" | { printf 'fcntl.h # ';  tr '\n' ' '; } >> c++11-headers.txt
cat /usr/include/unistd.h | grep extern | grep -v '__REDIRECT' | sort | uniq | awk '{ print $3; }' | perl -pe "chomp if eof" | { printf 'unistd.h # ';  tr '\n' ' '; } >> c++11-headers.txt
```

## NOTE
* iostream, cassert have lack of information
  * [標準ライブラリヘッダ <cassert> \- cppreference\.com]( https://ja.cppreference.com/w/cpp/header/cassert )
  * [標準ライブラリヘッダ <iostream> \- cppreference\.com]( https://ja.cppreference.com/w/cpp/header/iostream )
