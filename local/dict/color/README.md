# ansi color

## format
```
$COLOR_NAME:$ANSI_CODE:$HEX
```

## how to gen
```
./gen_color.sh
```

----

## FYI

how to correct data

### 256
```
curl 'https://jonasjacek.github.io/colors/' | pup 'tbody text{}' \
  | grep -v '(SYSTEM)' | grep -E -B 1 '#[0-9a-f]+' | grep -v '^--' | tr -d ' ' \
  | awk -v n=2 -v delim=":" 'NR%n!=1{printf "%s", delim;} {printf "%s", $0;} NR%n==0{printf "\n";}' | awk '{printf "\"%s\"\n", $0; }'
```

## full
```
curl 'https://www.december.com/html/spec/colorhex.html' | pup 'table.c tbody text{}' \
  | sed -E 's/\(.*\)//g' | sed -E 's/[^#a-zA-Z0-9]//g' | awk 'NF' \
  | awk -v n=2 -v delim=":" 'NR%n!=1{printf "%s", delim;} {printf "%s", $0;} NR%n==0{printf "\n";}' | awk '{printf "\"%s\"\n", $0; }'
```
