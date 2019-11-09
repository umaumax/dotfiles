// NOTE: default input file is input pipe
var inputFiles []string
if flag.NArg() == 0 {
  inputFiles = append(inputFiles, os.Stdin.Name())
} else {
  inputFiles = append(inputFiles, flag.Args()...)
}
for _, inputFile := range inputFiles {
  file, err := os.Open(inputFile)
  if err != nil {
    log.Fatal("file read error:", err)
  }
  defer file.Close()
}
