package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func solve11(input []int) int {
	numIncrements := 0
	base := input[0]
	for _, value := range input[1:] {
		if value > base {
			numIncrements += 1
		}
		base = value
	}
	return numIncrements
}

func makeWindowSlices(input []int) []int{
	slices := make([]int, 0, len(input)-3)
	for i, _ := range input[0:len(input)-2] {
		slices = append(slices, input[i] + input[i+1] + input[i+2])
	}
	return slices
}

func solve12(input []int) int {
	return solve11(makeWindowSlices(input))
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	file, err := os.Open("./aoc_1.input")
	check(err)
	defer func(file *os.File) {
		err := file.Close()
		if err != nil {
			check(err)
		}
	}(file)

	scanner := bufio.NewScanner(file)

	inputs := make([]int, 0, 100)

	for scanner.Scan() {
		intValue, err := strconv.Atoi(scanner.Text())
		check(err)
		inputs = append(inputs, intValue)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	result11 := solve11(inputs)
	fmt.Println("Result for 1 1: ", result11)

	result12 := solve12(inputs)
	fmt.Println("Results for 1 2: ", result12)
}
