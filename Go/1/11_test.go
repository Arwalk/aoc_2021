package main

import "testing"

func Test_solve11(t *testing.T) {
	input := []int{
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
	if solve11(input) != 7 {
		t.Fatalf("invalid value for solve_1_1")
	}
}