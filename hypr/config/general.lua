local colors = require("colors-hyprland")

hl.config({
	general = {
		border_size = 0,
		gaps_in = 3,
		gaps_out = 5,

		col = {
			active_border = {
				colors = {
					"rgb(" .. colors.color11:sub(2) .. ")",
					"rgb(" .. colors.color13:sub(2) .. ")",
				},
				angle = 45,
			},

			inactive_border = {
				colors = {
					"rgb(" .. colors.color11:sub(2) .. ")",
					"rgb(" .. colors.color13:sub(2) .. ")",
				},
				angle = 45,
			},
		},

		layout = "scrolling",
	},
})
