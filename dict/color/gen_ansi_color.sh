#!/usr/bin/env bash

color_list=(
	"0:default"
	"04:under_bar"
	#
	"30:black"
	"31:red"
	"32:green"
	"33:yellow"
	"34:blue"
	"35:purple,magenta"
	"36:light_blue"
	"37:white"
	#
	"40:black (background)"
	"41:red (background)"
	"42:green (background)"
	"43:yellow (background)"
	"44:blue (background)"
	"45:purple,magenta (background)"
	"46:blue (background)"
	"47:white (background)"
	#
	"90:black,gray,grey (light)"
	"91:red (light)"
	"92:green (light)"
	"93:yellow (light)"
	"94:blue (light)"
	"95:purple,magenta (light)"
	"96:blue (light)"
	"97:white (light)"
	#
	"100:black,gray,grey (light background)"
	"101:red (light background)"
	"102:green (light background)"
	"103:yellow (light background)"
	"104:blue (light background)"
	"105:purple,magenta (light background)"
	"106:blue (light background)"
	"107:white (light background)"
)

for line in "${color_list[@]}"; do
	no=${line%:*}
	color=${line##*:}
	printf $'\e[''%sm%-34s:$'"'"'\\e[%sm'"'"':'$'\e[''0m\n' "$no" "$color" "$no"
done
