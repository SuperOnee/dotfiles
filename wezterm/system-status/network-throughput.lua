package.path = "../util/?.lua;" .. package.path
local wezterm = require("wezterm")
local util = require("util.util")
local network_throughput = {}

function darwin_network_throughput()
	network_interface_list = { "en0" }
	if network_interface_list ~= nil then
		if #network_interface_list > 0 then
			for _, interface in ipairs(network_interface_list) do
				local r1, s1 = util.network_data_darwin(interface)
				_, _, _ = wezterm.run_child_process({ "sleep", "1" })
				local r2, s2 = util.network_data_darwin(interface)
				network_throughput = string.format(
					"%s %s / %s %s",
					wezterm.nerdfonts.md_download,
					util.process_bytes(r2 - r1),
					wezterm.nerdfonts.md_upload,
					util.process_bytes(s2 - s1)
				)
				return util.pad_string(2, 2, network_throughput)
			end
		end
	end
end

network_throughput.darwin_network_throughput = darwin_network_throughput

return network_throughput
