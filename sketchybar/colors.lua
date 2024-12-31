return {
	-- Main colors
	black = 0xff1e1e2e, -- Base
	white = 0xfffab387, -- Text
	red = 0xfff38ba8, -- Red
	green = 0xffa6e3a1, -- Green
	blue = 0xff89b4fa, -- Blue
	yellow = 0xfff9e2af, -- Yellow
	orange = 0xfffab387, -- Peach
	magenta = 0xffcba6f7, -- Mauve
	grey = 0xff585b70, -- Overlay1
	transparent = 0x00000000,
	bar = {
		bg = 0xff1e1e2e, --(Base)
		border = 0xff45475a, -- (Surface0)
	},
	popup = {
		bg = 0xff313244, -- (Surface1)
		border = 0xff585b70, -- (Overlay1)
	},
	bg1 = 0xff1e1e2e, -- (Base)
	bg2 = 0xff313244, -- (Surface1)

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
