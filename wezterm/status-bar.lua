local wezterm = require("wezterm")
local battery_status = require("battery-status")
local system_status = require("system-status.system-status")
local util = require("util.util")

status_bar = {}

function status_bar.update_status_bar(cwd)
	local cells = {}
	-- clock
	local date = wezterm.strftime("%a %b %-d %H:%M")
	table.insert(cells, util.pad_string(2, 2, date))

	-- battery
	if #wezterm.battery_info() > 0 then
		for _, b in ipairs(wezterm.battery_info()) do
			icon, battery_percent = battery_status.get_battery_status(b)
			bat = icon .. " " .. battery_percent
			table.insert(cells, util.pad_string(1, 1, bat))
		end
	end

	-- system status
	-- system_uptime = system_status.get_system_uptime()
	-- if system_uptime ~= nil then
	-- 	table.insert(cells, system_uptime)
	-- end

	cpu_usage = system_status.get_cpu_usage()
	if cpu_usage ~= nil then
		table.insert(cells, cpu_usage)
	end

	memory_usage = system_status.get_memory_usage()
	if memory_usage ~= nil then
		table.insert(cells, memory_usage)
	end

	disk_usage = system_status.get_disk_usage()
	if disk_usage ~= nil then
		for _, disk_usage_data in ipairs(disk_usage) do
			table.insert(cells, disk_usage_data)
		end
	end

	network_throughput = system_status.get_network_throughput()
	if network_throughput ~= nil then
		table.insert(cells, network_throughput)
	end
	return cells
end

return status_bar
