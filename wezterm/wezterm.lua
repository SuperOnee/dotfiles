local wezterm = require("wezterm")
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
	},
	font_size = 19,
	font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular" }),
	color_scheme = "Catppuccin Mocha",
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,
	window_background_opacity = 0.9,
	macos_window_background_blur = 70,
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

return config
