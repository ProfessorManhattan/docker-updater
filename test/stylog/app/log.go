package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	lggr "tideas/lggr/logger"

	"github.com/charmbracelet/glamour"
)

const (
	helpUsage = `NAME
	log - Format log message by type 
EXAMPLE:
	log info "Hello World"
	availale types info, success, error, star, warn
	OR
	log --md README.md
	this will output formated README.md file contents
	`

	wrongFileFormat = `Wrong file format, only *.md files are supported`
)

func renderMD(fn string) {

	if _, err := filepath.Match("*.md", filepath.Base(fn)); err != nil {
		log.Fatalf(wrongFileFormat)
	}

	md, err := os.ReadFile(fn)
	if err != nil {
		panic(err)
	}

	gout, err := glamour.RenderBytes(md, "dark")
	fmt.Printf("%s", gout)
}

func renderLog(lt string, msg string) {
	lf := lggr.NewLogFactory()
	lg, ok := lf.Get(lt)
	if !ok {
		fmt.Println(helpUsage)
		return
	}
	lg.Log(msg)
}

func main() {
	md := flag.Bool("md", false, "Prints formated *.md file")
	flag.Parse()
	args := flag.Args()

	if *md {
		renderMD(args[0])
		return
	}

	if len(args) < 2 {
		fmt.Println(helpUsage)
		return
	}

	renderLog(args[0], args[1])

}
