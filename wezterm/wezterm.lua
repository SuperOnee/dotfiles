local wezterm = require("wezterm")
local status_bar = require("status-bar")
local util = require("util.util")
local config = {
	-- Keymaps
	keys = {
		{
			key = "-",
			mods = "CTRL",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "=",
			mods = "CTRL",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "g",
			mods = "CTRL",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "j",
			mods = "CTRL",
			action = wezterm.action.DisableDefaultAssignment,
		},
	},
	font_size = 18,
	font = wezterm.font("JetbrainsMono Nerd Font Mono", { weight = "Regular" }),
	color_scheme = "Catppuccin Mocha",
	use_fancy_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = true,
	window_background_opacity = 0.85,
	macos_window_background_blur = 5,
	text_background_opacity = 0.9,
	adjust_window_size_when_changing_font_size = false,
	initial_rows = 30,
	initial_cols = 95,
	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 5,
	},
	default_cursor_style = "BlinkingBar",
	cursor_blink_rate = 500,
}

-- status bar
wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cwd = util.get_cwd(pane)

	-- Get system stats
	cells = status_bar.update_status_bar(cwd)

	-- The powerline < symbol
	local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled-in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	-- https://maketintsandshades.com/
	local colors = {
		"#f5e0dc",
		"#f2cdcd",
		"#f5c2e7",
		"#cba6f7",
		"#f38ba8",
		"#eba0ac",
		"#fab387",
		"#f9e2af",
		"#a6e3a1",
		"#94e2d5",
	}

	-- Foreground color for the text across the fade
	local text_fg = "#181825"
	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	function push(text, is_last)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

-- tab-title
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local title = util.basename(pane.foreground_process_name)
	local cwd = nil

	local cwd_uri = pane.current_working_dir
	if cwd_uri then
		cwd = cwd_uri.file_path
		cwd = string.gsub(cwd, wezterm.home_dir, "~")
		if cwd ~= nil then
			title = cwd
		end
	end

	local bg_color = "#f9e2af"
	if tab.is_active then
		bg_color = "#a6e3a1"
	elseif hover then
		bg_color = "#f38ba8"
	end

	return {
		{ Background = { Color = bg_color } },
		{ Foreground = { Color = "#181825" } },
		{ Text = util.pad_string(2, 2, title) },
	}
end)

return config
