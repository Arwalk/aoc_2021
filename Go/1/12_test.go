package main

import "testing"

var input = []int{
	199,
	200,
	208,
	210,
	200,
	207,
	240,
	269,
	260,
	263,
}

func Test_makeWindowSlice(t *testing.T) {
	slices := makeWindowSlices(input)
	expected := []int{
		607,
		618,
		618,
		617,
		647,
		716,
		769,
		792,
	}

	if len(slices) != len(expected) {
		t.Fatalf("invalid length, expected %d, found %d", len(expected), len(slices))
	}
}

func Test_solve12(t *testing.T) {
	value := solve12(input)

	if value != 5 {
		t.Fatalf("invalid value for solve_1_2: %d", value)
	}
}
