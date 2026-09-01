package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"time"
)

// --- File Operations ---

func ReadFile(path string) (string, error) {
	data, err := os.ReadFile(path)
	return string(data), err
}

func ReadLines(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

func WriteJSON(path string, v interface{}) error {
	data, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(path, data, 0644)
}

// --- String Utils ---

func Slugify(s string) string {
	s = strings.ToLower(strings.TrimSpace(s))
	s = strings.Join(strings.Fields(s), "-")
	return s
}

func ContainsAny(s string, subs ...string) bool {
	for _, sub := range subs {
		if strings.Contains(s, sub) {
			return true
		}
	}
	return false
}

// --- Functional Utils ---

func Filter[T any](slice []T, fn func(T) bool) []T {
	var result []T
	for _, item := range slice {
		if fn(item) {
			result = append(result, item)
		}
	}
	return result
}

func Map[T, U any](slice []T, fn func(T) U) []U {
	result := make([]U, len(slice))
	for i, item := range slice {
		result[i] = fn(item)
	}
	return result
}

func Unique[T comparable](slice []T) []T {
	seen := make(map[T]bool)
	var result []T
	for _, item := range slice {
		if !seen[item] {
			seen[item] = true
			result = append(result, item)
		}
	}
	return result
}

// --- Timer ---

func TimeIt(name string, fn func()) {
	start := time.Now()
	fn()
	fmt.Printf("%s: %v\n", name, time.Since(start))
}

func main() {
	fmt.Println("Slugify:", Slugify("Hello World Test"))

	nums := []int{1, 2, 2, 3, 3, 4, 5}
	evens := Filter(nums, func(n int) bool { return n%2 == 0 })
	fmt.Println("Evens:", evens)

	doubled := Map(nums, func(n int) int { return n * 2 })
	fmt.Println("Doubled:", doubled)

	fmt.Println("Unique:", Unique([]string{"a", "b", "a", "c"}))

	TimeIt("sleep", func() {
		time.Sleep(100 * time.Millisecond)
	})
}
