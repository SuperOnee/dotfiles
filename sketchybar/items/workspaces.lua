-- NOTE: The code below is a modified version of this github dicussion
-- https://github.com/FelixKratz/SketchyBar/discussions/599

-- items/workspaces.lua
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local icons = require("icons")

local max_workspaces = 10
local query_workspaces =
	"aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"
local workspace_monitor = {}

-- Add padding to the left
sbar.add("item", {
	icon = {
		color = colors.with_alpha(colors.white, 0.3),
		highlight_color = colors.white,
		drawing = false,
	},
	label = {
		color = colors.grey,
		highlight_color = colors.white,
		drawing = false,
	},
	background = {
		color = colors.bg0,
		border_width = 1,
		height = 28,
		border_color = colors.black,
		corner_radius = 9,
		drawing = false,
	},
	padding_left = 6,
	padding_right = 0,
})

local workspaces = {}

local function updateWindows(workspace_index)
	local get_windows =
		string.format("aerospace list-windows --workspace %s --format '%%{app-name}' --json", workspace_index)
	local get_focus_workspaces = "aerospace list-workspaces --focused"
	sbar.exec(get_windows, function(open_windows)
		sbar.exec(get_focus_workspaces, function(focused_workspaces)
			sbar.exec(query_workspaces, function(all_workspaces)
				local icon_line = ""
				local no_app = true
				for i, open_window in ipairs(open_windows) do
					no_app = false
					local app = open_window["app-name"]
					local lookup = app_icons[app]
					local icon = ((lookup == nil) and app_icons["Default"] or lookup)
					icon_line = icon_line .. " " .. icon
				end

				sbar.animate("tanh", 10, function()
					for i, visible_workspace in ipairs(all_workspaces) do
						if no_app and workspace_index == tonumber(visible_workspace["workspace"]) then
							local monitor_id = visible_workspace["monitor-appkit-nsscreen-screens-id"]
							icon_line = " —"
							workspaces[workspace_index]:set({
								icon = { drawing = true },
								label = {
									string = icon_line,
									drawing = true,
									-- padding_right = 20,
									font = "sketchybar-app-font:Regular:16.0",
									y_offset = -1,
								},
								background = { drawing = true },
								padding_right = 1,
								padding_left = 1,
								display = monitor_id,
							})
							return
						end
					end
					if no_app and workspace_index ~= tonumber(focused_workspaces) then
						workspaces[workspace_index]:set({
							icon = { drawing = false },
							label = { drawing = false },
							background = { drawing = false },
							padding_right = 0,
							padding_left = 0,
						})
						return
					end
					if no_app and workspace_index == tonumber(focused_workspaces) then
						icon_line = " —"
						workspaces[workspace_index]:set({
							icon = { drawing = true },
							label = {
								string = icon_line,
								drawing = true,
								-- padding_right = 20,
								font = "sketchybar-app-font:Regular:16.0",
								y_offset = -1,
							},
							background = { drawing = true },
							padding_right = 1,
							padding_left = 1,
						})
					end

					workspaces[workspace_index]:set({
						icon = { drawing = true },
						label = { drawing = true, string = icon_line },
						background = { drawing = true },
						padding_right = 1,
						padding_left = 1,
					})
				end)
			end)
		end)
	end)
end

local function updateWorkspaceMonitor(workspace_index)
	sbar.exec(query_workspaces, function(workspaces_and_monitors)
		for _, entry in ipairs(workspaces_and_monitors) do
			local space_index = tonumber(entry.workspace)
			local monitor_id = math.floor(entry["monitor-appkit-nsscreen-screens-id"])
			workspace_monitor[space_index] = monitor_id
		end
		workspaces[workspace_index]:set({
			display = workspace_monitor[workspace_index],
		})
	end)
end

for workspace_index = 1, max_workspaces do
	local workspace = sbar.add("item", {
		icon = {
			color = colors.with_alpha(colors.white, 0.3),
			highlight_color = colors.green,
			drawing = false,
			font = { family = settings.font.numbers },
			string = workspace_index,
			padding_left = 10,
			padding_right = 5,
		},
		label = {
			padding_right = 10,
			color = colors.with_alpha(colors.white, 0.3),
			highlight_color = colors.green,
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = -1,
		},
		padding_right = 2,
		padding_left = 2,
		background = {
			color = colors.bg3,
			border_width = 1,
			height = 28,
			border_color = colors.bg2,
		},
		click_script = "aerospace workspace " .. workspace_index,
	})

	workspaces[workspace_index] = workspace

	workspace:subscribe("aerospace_workspace_change", function(env)
		local focused_workspace = tonumber(env.FOCUSED_WORKSPACE)
		local is_focused = focused_workspace == workspace_index

		sbar.animate("tanh", 10, function()
			workspace:set({
				icon = { highlight = is_focused },
				label = { highlight = is_focused },
				background = {
					border_width = is_focused and 2 or 1,
				},
				blur_radius = 30,
			})
		end)
		updateWindows(workspace_index)
	end)

	workspace:subscribe("aerospace_focus_change", function()
		updateWindows(workspace_index)
	end)

	workspace:subscribe("display_change", function()
		updateWorkspaceMonitor(workspace_index)
		updateWindows(workspace_index)
	end)

	-- initial setup
	updateWorkspaceMonitor(workspace_index)
	updateWindows(workspace_index)
	sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
		workspaces[tonumber(focused_workspace)]:set({
			icon = { highlight = true },
			label = { highlight = true },
			background = { border_width = 2 },
		})
	end)
end

local spaces_indicator = sbar.add("item", {
	padding_left = 2,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
