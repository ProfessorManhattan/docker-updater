package lggr

import (
	"fmt"
	"regexp"

	wordwrap "github.com/mitchellh/go-wordwrap"
)

const (
	MessageMaxWidth = 80
)

var (
	cols              = getStdOutColumns()
	emphasized        = regexp.MustCompile(`\x{0060}(.*)\x{0060}`)
	bolded            = regexp.MustCompile(`\*(.*)\*`)
	logDecoratorRegex = regexp.MustCompile(`[\x{001B}\x{009B}][#();?[]*(?:\d{1,4}(?:;\d{0,4})*)?[\d<=>A-ORZcf-nqry]`)
)

func LogDecoratorRegex() *regexp.Regexp {
	return logDecoratorRegex
}

func wrapMessage(m string) string {
	if cols > MessageMaxWidth {
		m = wordwrap.WrapString(m, MessageMaxWidth)
	}
	return m
}

func styler(m string) string {
	m = bolded.ReplaceAllString(m, applyStyle(bold, "$1"))
	m = emphasized.ReplaceAllString(m, applyStyle(whiteOnGray, "$1"))
	return m
}

func LogInstructions(t string, m string) {
	ft := fmt.Sprintf("\n%s", applyStyle(whiteOnBlue, fmt.Sprintf("   %s   ", t)))
	fmt.Printf("%s\n\n", ft)
	m = wrapMessage(m)
	fmt.Printf("%s\n\n", m)
}

func LogRaw(m string) {
	m = wrapMessage(m)
	fmt.Printf("%s\n", m)
}

func Info(m string) {
	fmt.Printf("\n%s %s\n", applyStyle(blue, `●`), styler(m))
}

func Error(m string) {
	fmt.Printf("\n%s\n%s %s\n", applyStyle(whiteOnRedBolded, `   ERROR   `), applyStyle(whiteBold, `┗`), styler(m))
}

func Star(m string) {
	fmt.Printf("\n%s %s\n\n", `⭐`, styler(m))
}

func Success(m string) {
	fmt.Printf("%s %s\n", applyStyle(greenBold, `✔`), styler(m))
}

func Warn(m string) {
	fmt.Printf("\n%s\n%s %s\n\n", applyStyle(blackOnYellowBolded, `   WARN   `), applyStyle(whiteBold, `┗`), styler(m))
}
