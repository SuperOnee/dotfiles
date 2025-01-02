package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"
)

func main() {
	// get symbol from command line
	symbol := os.Args[1]

	if symbol == "" {
		fmt.Println("Error: symbol is required")
		return
	}

	querySymbol := fmt.Sprintf("%sUSDT", strings.ToUpper(symbol))

	url := fmt.Sprintf("https://api.binance.com/api/v3/ticker/24hr?symbol=%s", querySymbol)

	client := http.Client{
		Timeout: 5 * time.Second,
	}

	resp, err := client.Get(url)
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	fmt.Println(string(body))
}
