package lggr

import (
	"fmt"
	log "tideas/lggr"
)

type Logger interface {
	Log(v ...interface{})
	Logf(format string, v ...interface{})
}

type LogFactory struct {
	logger map[string]Logger
}

func (lf *LogFactory) Register(t string, l Logger) {
	lf.logger[t] = l
}

func (lf *LogFactory) Get(t string) (Logger, bool) {
	cb, ok := lf.logger[t]
	return cb, ok
}

type Info struct {
}

func (i *Info) Log(v ...interface{}) {
	log.Info(fmt.Sprint(v...))
}

func (i *Info) Logf(format string, v ...interface{}) {
	log.Info(fmt.Sprintf(format, v...))
}

type Error struct {
}

func (e *Error) Log(v ...interface{}) {
	log.Error(fmt.Sprint(v...))
}

func (e *Error) Logf(format string, v ...interface{}) {
	log.Error(fmt.Sprintf(format, v...))
}

type Star struct {
}

func (s *Star) Log(v ...interface{}) {
	log.Star(fmt.Sprint(v...))
}

func (s *Star) Logf(format string, v ...interface{}) {
	log.Star(fmt.Sprintf(format, v...))
}

type Success struct {
}

func (s *Success) Log(v ...interface{}) {
	log.Success(fmt.Sprint(v...))
}

func (s *Success) Logf(format string, v ...interface{}) {
	log.Success(fmt.Sprintf(format, v...))
}

type Warn struct {
}

func (w *Warn) Log(v ...interface{}) {
	log.Warn(fmt.Sprint(v...))
}

func (w *Warn) Logf(format string, v ...interface{}) {
	log.Warn(fmt.Sprintf(format, v...))
}

func NewLogFactory() *LogFactory {

	lf := LogFactory{make(map[string]Logger)}

	lf.Register("info", &Info{})
	lf.Register("error", &Error{})
	lf.Register("star", &Star{})
	lf.Register("success", &Success{})
	lf.Register("warn", &Warn{})

	return &lf
}
