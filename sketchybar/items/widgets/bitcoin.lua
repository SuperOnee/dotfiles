local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local http_request = require("http.request")
local json = require("dkjson")

local btc_pair = "BTCUSDT"
local eth_pair = "ETHUSDT"

local ethereum = sbar.add("item", "widgets.ethereum", 42, {
	position = "right",
	background = {
		height = 30,
		color = { alpha = 0 },
		border_color = { alpha = 0 },
		drawing = true,
	},
	icon = { string = icons.ethereum, font = { size = 16 }, color = colors.blue },
	label = {
		string = "??$ ??%",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 10,
		},
		align = "right",
		padding_right = settings.paddings,
		y_offset = 0,
	},
	update_freq = 15,
	updates = true,
	padding_right = settings.paddings,
})

local bitcoin = sbar.add("item", "widgets.bitcoin", 42, {
	position = "right",
	background = {
		height = 30,
		color = { alpha = 0 },
		border_color = { alpha = 0 },
		drawing = true,
	},
	icon = { string = icons.bitcoin, font = { size = 16 }, color = colors.orange },
	label = {
		string = "??$ ??%",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 10,
		},
		align = "right",
		padding_right = settings.paddings,
		y_offset = 0,
	},
	updates = true,
	update_freq = 15,
	padding_right = settings.paddings,
})

sbar.add("bracket", "widgets.bitcoin.bracket", { ethereum.name, bitcoin.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "widgets.bitcoin.padding", {
	position = "right",
	width = settings.group_paddings,
})

local function fetch_bitcoin_ticker(trading_pair)
	local url = "https://api.binance.com/api/v3/ticker/24hr?symbol=" .. trading_pair
	local req = http_request.new_from_uri(url)
	req.timeout = 3
	local headers, stream = req:go()
	if headers then
		local body, _ = stream:get_body_as_string()
		if body then
			local data, _, err = json.decode(body, 1, nil)
			if err then
				return
			else
				local current_price = tonumber(data.lastPrice)
				local price_change_percent = tonumber(data.priceChangePercent)
				local price_as_integer = math.floor(current_price or 0)
				local change_with_two_decimals = string.format("%.2f", price_change_percent)
				return price_as_integer, change_with_two_decimals
			end
		end
		return
	end
end

local function update_bitcoin_price()
	local price, change = fetch_bitcoin_ticker(btc_pair)
	if price and change then
		local text_color = colors.green
		if tonumber(change) < 0 then
			text_color = colors.red
		end
		bitcoin:set({
			label = { string = price .. "$ " .. change .. "%", color = text_color },
		})
	end
end

local function update_ethereum_price()
	local price, change = fetch_bitcoin_ticker(eth_pair)
	if price and change then
		local text_color = colors.green
		if tonumber(change) < 0 then
			text_color = colors.red
		end
		ethereum:set({
			label = { string = price .. "$ " .. change .. "%", color = text_color },
		})
	end
end

local function update_crypto_prices()
	-- launch coroutines to fetch prices
	local co1 = coroutine.create(update_bitcoin_price)
	local co2 = coroutine.create(update_ethereum_price)
	coroutine.resume(co1)
	coroutine.resume(co2)
end

-- setup
update_crypto_prices()

bitcoin:subscribe({ "routine" }, update_crypto_prices)
