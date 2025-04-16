require("git"):setup()

THEME.git = THEME.git or {}
THEME.git.modified = ui.Style():fg("blue")
THEME.git.deleted = ui.Style():fg("red"):bold()

-- ~/.config/yazi/init.lua
function Linemode:size()
	local size = self._file:size()
	return size and ya.readable_size(size) or ""
end
