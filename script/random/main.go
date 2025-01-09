package main

import (
	"fmt"
	"math/rand"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) <= 1 {
		fmt.Println("Error: value is required!")
		return
	}

	str := os.Args[1]

	maxValue, err := strconv.ParseInt(str, 10, 64)
	randomNumber := rand.Intn(int(maxValue)) + 1
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	fmt.Println("Running result:", randomNumber)
}
