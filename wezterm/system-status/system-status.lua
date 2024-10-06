local wezterm = require("wezterm")
local system_status = {}

local folderOfThisFile = (...):match("(.-)[^%.]+$")

local cpu_usage = require(folderOfThisFile .. "cpu-usage")
local disk_usage = require(folderOfThisFile .. "disk-usage")
local memory_usage = require(folderOfThisFile .. "memory-usage")
local network_throughput = require(folderOfThisFile .. "network-throughput")
local uptime = require(folderOfThisFile .. "uptime")

function get_cpu_usage()
	return cpu_usage.darwin_cpu_usage()
end

function get_disk_usage(config)
	return disk_usage.darwin_disk_usage(config)
end

function get_memory_usage(config)
	return memory_usage.darwin_memory_usage(config)
end

function get_network_throughput(config)
	return network_throughput.darwin_network_throughput(config)
end

function get_system_uptime(config)
	return uptime.darwin_uptime(config)
end

system_status.get_cpu_usage = get_cpu_usage
system_status.get_disk_usage = get_disk_usage
system_status.get_load_averages = get_load_averages
system_status.get_memory_usage = get_memory_usage
system_status.get_network_throughput = get_network_throughput
system_status.get_system_uptime = get_system_uptime

return system_status
