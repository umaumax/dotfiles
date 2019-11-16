// NOTE: default input file is input pipe
inputFiles := []string{"-"}
if flag.NArg() > 0 {
	inputFiles = flag.Args()
}
for _, inputFile := range inputFiles {
	file := os.Stdin
	if inputFile != "-" {
		file, err := os.Open(inputFile)
		if err != nil {
			log.Fatal("file read error:", err)
		}
		defer file.Close()
	}
}
