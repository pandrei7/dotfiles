package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
)

type Scanner struct {
	*bufio.Scanner
}

func NewWordScanner(reader io.Reader) *Scanner {
	scanner := bufio.NewScanner(reader)
	scanner.Split(bufio.ScanWords)
	return &Scanner{scanner}
}

func (s *Scanner) Word() string {
	s.Scan()
	return s.Text()
}

func (s *Scanner) Int() int {
	s.Scan()
	n, _ := strconv.Atoi(s.Text())
	return n
}

func (s *Scanner) Int64() int64 {
	s.Scan()
	n, _ := strconv.ParseInt(s.Text(), 10, 64)
	return n
}

func (s *Scanner) Words(count int) []string {
	words := make([]string, count)
	for i := range words {
		words[i] = s.Word()
	}
	return words
}

func (s *Scanner) Ints(count int) []int {
	ints := make([]int, count)
	for i := range ints {
		ints[i] = s.Int()
	}
	return ints
}

func (s *Scanner) Int64s(count int) []int64 {
	int64s := make([]int64, count)
	for i := range int64s {
		int64s[i] = s.Int64()
	}
	return int64s
}

func main() {
	stdin := NewWordScanner(os.Stdin)
}
