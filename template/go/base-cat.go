package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
)

func init() {
}

func main() {
	flag.Parse()

	var filepath string
	var err error
	var f *os.File
	if flag.NArg() >= 1 {
		filepath = flag.Arg(0)
		f, err = os.Open(filepath)
		if err != nil {
			log.Fatalln(err)
		}
		defer f.Close()
	} else {
		f = os.Stdin
	}

	ReadLine(f)
}
func ReadLine(r io.Reader) {
	scanner := bufio.NewScanner(r)
	i := 0
	for scanner.Scan() {
		i++
		line := scanner.Text()
		fmt.Println(i, line)
	}
	var err error
	if err = scanner.Err(); err != nil {
		log.Fatalln(err)
	}
}
