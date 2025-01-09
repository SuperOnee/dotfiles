package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

type CryptoData struct {
	Symbol             string `json:"symbol"`
	PriceChange        string `json:"priceChange"`
	PriceChangePercent string `json:"priceChangePercent"`
	WeightedAvgPrice   string `json:"weightedAvgPrice"`
	PrevClosePrice     string `json:"prevClosePrice"`
	LastPrice          string `json:"lastPrice"`
	LastQty            string `json:"lastQty"`
	BidPrice           string `json:"bidPrice"`
	BidQty             string `json:"bidQty"`
	AskPrice           string `json:"askPrice"`
	AskQty             string `json:"askQty"`
	OpenPrice          string `json:"openPrice"`
	HighPrice          string `json:"highPrice"`
	LowPrice           string `json:"lowPrice"`
	Volume             string `json:"volume"`
	QuoteVolume        string `json:"quoteVolume"`
	OpenTime           int64  `json:"openTime"`
	CloseTime          int64  `json:"closeTime"`
	FirstId            int64  `json:"firstId"`
	LastId             int64  `json:"lastId"`
	Count              int64  `json:"count"`
}

func main() {
	// get symbol from command line
	if len(os.Args) <= 1 {
		fmt.Println("Error: symbol is required")
		return
	}
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

	data := CryptoData{}
	json.Unmarshal(body, &data)

	lastPrice, err := strconv.ParseFloat(data.LastPrice, 64)
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	priceChangePercent, err := strconv.ParseFloat(data.PriceChangePercent, 64)
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	PriceChangeRes := struct {
		CurrentPrice       string `json:"currentPrice"`
		PriceChangePercent string `json:"priceChangePercent"`
	}{
		CurrentPrice:       fmt.Sprintf("%d", int(lastPrice)),
		PriceChangePercent: fmt.Sprintf("%.2f", priceChangePercent),
	}

	res, err := json.Marshal(PriceChangeRes)
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	fmt.Println(string(res))
}
