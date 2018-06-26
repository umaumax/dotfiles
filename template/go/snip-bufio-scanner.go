scanner := bufio.NewScanner(r)
n := 0
for scanner.Scan() {
	line := scanner.Text()
	n++
}
if err = scanner.Err(); err != nil {
	return
}
