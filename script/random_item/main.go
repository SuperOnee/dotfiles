package main

import (
	"fmt"
	"math/rand"
	"os"
	"strings"
)

func main() {
	if len(os.Args) <= 1 {
		fmt.Println("Error: value is required!")
		return
	}

	str := os.Args[1]

	items := strings.Split(str, ",")

	ranIndex := rand.Intn(len(items))

	fmt.Println("Machine chose:", items[ranIndex])
}
