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

sbar.add("bracket", "widgets.crypto.bracket", { ethereum.name, bitcoin.name }, {
	background = { color = colors.bg1 },
})

bitcoin:subscribe({ "routine" }, function()
	sbar.exec("~/.config/script/crypto btc", function(res)
		if res then
			local current_price = tonumber(res["currentPrice"])
			local price_change_percent = tonumber(res["priceChangePercent"])

			local color = colors.green
			if price_change_percent < 0 then
				color = colors.red
			end

			bitcoin:set({
				label = {
					string = current_price .. "$" .. " " .. price_change_percent .. "%",
					color = color,
				},
			})
		end
	end)
end)

ethereum:subscribe({ "routine" }, function()
	sbar.exec("~/.config/script/crypto eth", function(res)
		if res then
			local current_price = tonumber(res["currentPrice"])
			local price_change_percent = tonumber(res["priceChangePercent"])

			local color = colors.green
			if price_change_percent < 0 then
				color = colors.red
			end

			ethereum:set({
				label = {
					string = current_price .. "$" .. " " .. price_change_percent .. "%",
					color = color,
				},
			})
		end
	end)
end)
