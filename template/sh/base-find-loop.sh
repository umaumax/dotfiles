#!/usr/bin/env bash

find . -name "*.xxx" | while read filename || [ -n "${filename}" ]; do
	echo $filename
done
