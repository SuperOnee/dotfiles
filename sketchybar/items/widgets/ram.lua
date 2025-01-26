local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("graph", "widgets.ram", 42, {
	position = "right",
	graph = { color = colors.blue },
	background = {
		height = 22,
		color = { alpha = 0 },
		border_color = { alpha = 0 },
		drawing = true,
	},
	icon = { string = icons.ram },
	label = {
		string = "ram ??%",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		align = "right",
		padding_right = 0,
		width = 0,
		y_offset = 4,
	},
	update_freq = 3,
	updates = true,
	padding_right = settings.paddings + 6,
})

sbar.add("bracket", "widgets.ram.bracket", { ram.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "widgets.ram.padding", {
	position = "right",
	width = settings.group_paddings,
})

ram:subscribe({ "routine", "forced", "system_woke" }, function(env)
	sbar.exec("sysctl -n hw.pagesize", function(page_size_output)
		local page_size = tonumber(page_size_output)
		if not page_size_output or page_size == 0 then
			return
		end

		sbar.exec("vm_stat", function(vm_stat_output)
			if not vm_stat_output then
				return
			end

			local pages_free = tonumber(vm_stat_output:match("Pages free:%s+(%d+)")) or 0
			local pages_active = tonumber(vm_stat_output:match("Pages active:%s+(%d+)")) or 0
			local pages_inactive = tonumber(vm_stat_output:match("Pages inactive:%s+(%d+)")) or 0
			local pages_speculative = tonumber(vm_stat_output:match("Pages speculative:%s+(%d+)")) or 0
			local pages_wired = tonumber(vm_stat_output:match("Pages wired down:%s+(%d+)")) or 0
			local pages_compressed = tonumber(vm_stat_output:match("Pages occupied by compressor:%s+(%d+)")) or 0

			local total_pages = pages_free
				+ pages_active
				+ pages_inactive
				+ pages_speculative
				+ pages_wired
				+ pages_compressed
			local used_pages = pages_active + pages_wired + pages_compressed + pages_speculative

			local total_memory = total_pages * page_size
			local used_memory = used_pages * page_size
			local memory_usage = (used_memory / total_memory) * 100

			local color = colors.blue
			if memory_usage > 30 then
				if memory_usage < 60 then
					color = colors.yellow
				elseif memory_usage < 80 then
					color = colors.orange
				else
					color = colors.red
				end
			end

			ram:set({
				graph = { color = color },
				label = { string = "ram " .. string.format("%.0f", memory_usage) .. "%" },
			})
		end)
	end)
end)
