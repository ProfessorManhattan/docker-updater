package lggr

import "golang.org/x/crypto/ssh/terminal"

func getStdOutColumns() int {
	// "terminal.GetSize(0)" assuming current terminal is a dfault one
	width, _, err := terminal.GetSize(0)
	if err != nil {
		// reasonable default for unknown terminal width is 80 ergo MessageMaxWidth = 80 is used by default
		width = MessageMaxWidth
	}

	return width
}
