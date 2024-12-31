local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local https = require("ssl.https")
local json = require("dkjson")

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
	update_freq = 3,
	updates = true,
	padding_right = settings.paddings,
})

sbar.add("bracket", "widgets.bitcoin.bracket", { bitcoin.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "widgets.bitcoin.padding", {
	position = "right",
	width = settings.group_paddings,
})

local function fetch_bitcoin_ticker()
	local url = "https://api.binance.com/api/v3/ticker/24hr?symbol=BTCUSDT"
	local response, status_code = https.request(url)
	if status_code == 200 then
		local data, _, err = json.decode(response, 1, nil)
		if err then
			return
		else
			local current_price = tonumber(data.lastPrice)
			local price_change_percent = tonumber(data.priceChangePercent)
			local price_as_integer = math.floor(current_price)
			local change_with_two_decimals = string.format("%.2f", price_change_percent)

			return price_as_integer, change_with_two_decimals
		end
	else
		return
	end
end

bitcoin:subscribe({ "routine", "forced", "system_woke" }, function(_)
	local price, change = fetch_bitcoin_ticker()
	local text_color = colors.green
	if tonumber(change) < 0 then
		text_color = colors.red
	end
	if price then
		bitcoin:set({
			label = { string = price .. "$ " .. change .. "%", color = text_color },
		})
	end
end)
