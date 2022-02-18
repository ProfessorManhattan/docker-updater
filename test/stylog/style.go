package lggr

import (
	color "github.com/fatih/color"
)

var (
	whiteOnBlue         = color.New(color.FgWhite).Add(color.BgHiBlue)
	whiteOnGray         = color.New(color.FgHiWhite).Add(color.BgHiBlack)
	bold                = color.New(color.Bold)
	blue                = color.New(color.FgHiBlue)
	whiteOnRedBolded    = color.New(color.FgHiWhite).Add(color.BgHiRed).Add(color.Bold)
	whiteBold           = color.New(color.FgWhite).Add(color.Bold)
	greenBold           = color.New(color.FgGreen).Add(color.Bold)
	blackOnYellowBolded = color.New(color.FgBlack).Add(color.BgHiYellow).Add(color.Bold)
)

func applyStyle(st *color.Color, s string) string {
	sts := st.Sprintf("%s", s)
	return sts
}
