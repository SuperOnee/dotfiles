local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

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
		string = "loading...",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 10,
		},
		align = "right",
		padding_right = settings.paddings,
	},
	update_freq = 3,
	updates = true,
	padding_right = settings.paddings + 6,
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
		string = "loading...",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 10,
		},
		align = "right",
		padding_right = settings.paddings,
	},
	updates = true,
	update_freq = 3,
	padding_right = settings.paddings,
})

local crypto_bracket = sbar.add(
	"bracket",
	"widgets.crypto.bracket",
	{ ethereum.name, bitcoin.name },
	{ background = { color = colors.bg1 }, popup = { align = "center" } }
)

local last_changes = {}

local diff_changes = {}

local crypto_symbols = {
	{
		symbol = "bnb",
		name = "bnb",
		decimals = 2,
	},
	{
		symbol = "doge",
		name = "dogecoin",
		decimals = 4,
	},
	{
		symbol = "sol",
		name = "solana",
		decimals = 2,
	},
	{
		symbol = "xrp",
		name = "xrp",
		decimals = 3,
	},
	{
		symbol = "ada",
		name = "cardano",
		decimals = 4,
	},
	{
		symbol = "sui",
		name = "sui",
		decimals = 3,
	},
	{
		symbol = "ton",
		name = "toncoin",
		decimals = 3,
	},
	{
		symbol = "pol",
		name = "polygon-ecosystem-token",
		decimals = 4,
	},
}

local crypto_items = {}

for _, symbol in ipairs(crypto_symbols) do
	local popup = sbar.add("item", "widgets.crypto." .. symbol.symbol, 42, {
		position = "popup." .. crypto_bracket.name,
		background = {
			height = 30,
			image = {
				string = "~/.config/sketchybar/icons/" .. symbol.symbol .. ".png",
				scale = 0.33,
			},
			color = colors.transparent,
		},
		icon = {
			string = symbol.symbol:upper(),
			width = 70,
			align = "left",
			padding_left = 25,
		},
		label = {
			string = "loading...",
			align = "right",
			padding_left = 6,
		},
	})
	table.insert(crypto_items, popup)
end

local refresh_item = function(symbol, decimals, item)
	sbar.exec("~/.config/script/crypto/main " .. symbol .. " " .. decimals, function(res)
		if res then
			local current_price = tonumber(res["currentPrice"])
			local price_change_percent = tonumber(res["priceChangePercent"])

			local color = colors.green
			if price_change_percent < 0 then
				color = colors.red
			end

			local last_change = last_changes[symbol]
			-- default to 0.1
			local diff_change = diff_changes[symbol] or 0.1
			if last_change then
				local new_diff = math.max(0, diff_change + (price_change_percent - last_change))
				if new_diff > 0.5 then
					new_diff = 0.5
				end
				diff_changes[symbol] = new_diff
				item:push({ new_diff })
			end

			last_changes[symbol] = price_change_percent

			item:set({
				label = {
					string = current_price .. "$" .. " " .. price_change_percent .. "%",
					color = color,
				},
			})
		end
	end)
end

local refresh_crypto_list = function()
	for i, popup in ipairs(crypto_items) do
		local symbol = crypto_symbols[i]
		refresh_item(symbol.symbol, symbol.decimals, popup)
	end
end

local toggle_popup = function()
	local should_draw = crypto_bracket:query().popup.drawing == "off"
	if should_draw then
		crypto_bracket:set({ popup = { drawing = true } })
	else
		crypto_bracket:set({ popup = { drawing = false } })
	end
end

local open_cmc = function(crypto_symbol)
	sbar.exec("open https://coinmarketcap.com/currencies/" .. crypto_symbol)
end

-- Subscribe to mouse events
for i, popup in ipairs(crypto_items) do
	popup:subscribe("mouse.clicked", function()
		local name = crypto_symbols[i].name
		open_cmc(name)
	end)
end

bitcoin:subscribe("mouse.clicked", function()
	toggle_popup()
end)

ethereum:subscribe("mouse.clicked", function()
	toggle_popup()
end)

bitcoin:subscribe({ "routine" }, function()
	refresh_item("btc", 0, bitcoin)
	-- local popup_drawing = crypto_bracket:query().popup.drawing == "on"
	-- if popup_drawing then
	refresh_crypto_list()
	-- end
end)

ethereum:subscribe({ "routine" }, function()
	refresh_item("eth", 0, ethereum)
end)
