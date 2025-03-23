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
		y_offset = 0,
	},
	update_freq = 3,
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
		string = "loading...",
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
	update_freq = 3,
	padding_right = settings.paddings,
})

local crypto_bracket = sbar.add(
	"bracket",
	"widgets.crypto.bracket",
	{ ethereum.name, bitcoin.name },
	{ background = { color = colors.bg1 }, popup = { align = "center" } }
)

local bnb_popup = sbar.add("item", {
	position = "popup." .. crypto_bracket.name,
	icon = {
		string = "BNB",
		width = 60,
		align = "left",
	},
	label = {
		string = "loading...",
		width = 100,
		align = "right",
	},
})

local sol_popup = sbar.add("item", {
	position = "popup." .. crypto_bracket.name,
	icon = {
		string = "SOL",
		width = 60,
		align = "left",
	},
	label = {
		string = "loading...",
		width = 100,
		align = "right",
	},
})

local xrp_popup = sbar.add("item", {
	position = "popup." .. crypto_bracket.name,
	icon = {
		string = "XRP",
		width = 60,
		align = "left",
	},
	label = {
		string = "loading...",
		width = 100,
		align = "right",
	},
})

local ton_popup = sbar.add("item", {
	position = "popup." .. crypto_bracket.name,
	icon = {
		string = "TON",
		width = 60,
		align = "left",
	},
	label = {
		string = "loading...",
		width = 100,
		align = "right",
	},
})

local doge_popup = sbar.add("item", {
	position = "popup." .. crypto_bracket.name,
	icon = {
		string = "DOGE",
		width = 60,
		align = "left",
	},
	label = {
		string = "loading...",
		width = 100,
		align = "right",
	},
})

local pol_popup = sbar.add("item", {
	position = "popup." .. crypto_bracket.name,
	icon = {
		string = "POL",
		width = 60,
		align = "left",
	},
	label = {
		string = "loading...",
		width = 100,
		align = "right",
	},
})

local refresh_item = function(symbol, decimals, item)
	sbar.exec("~/.config/script/crypto/main " .. symbol .. " " .. decimals, function(res)
		if res then
			local current_price = tonumber(res["currentPrice"])
			local price_change_percent = tonumber(res["priceChangePercent"])

			local color = colors.green
			if price_change_percent < 0 then
				color = colors.red
			end

			item:set({
				label = {
					string = current_price .. "$" .. " " .. price_change_percent .. "%",
					color = color,
				},
			})
		end
	end)
end

local load_details = function()
	refresh_item("bnb", 2, bnb_popup)
	refresh_item("sol", 2, sol_popup)
	refresh_item("xrp", 2, xrp_popup)
	refresh_item("ton", 2, ton_popup)
	refresh_item("doge", 4, doge_popup)
	refresh_item("pol", 4, pol_popup)
end

local toggle_popup = function()
	local should_draw = crypto_bracket:query().popup.drawing == "off"
	if should_draw then
		crypto_bracket:set({ popup = { drawing = true } })
		load_details()
	else
		crypto_bracket:set({ popup = { drawing = false } })
	end
end

bitcoin:subscribe("mouse.clicked", function()
	toggle_popup()
end)

ethereum:subscribe("mouse.clicked", function()
	toggle_popup()
end)

bitcoin:subscribe({ "routine" }, function()
	refresh_item("btc", 0, bitcoin)
end)

ethereum:subscribe({ "routine" }, function()
	refresh_item("eth", 0, ethereum)
end)
