hl.config({
	decoration = {
		rounding = 0,
		rounding_power = 1.0,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		fullscreen_opacity = 1.0,
		-- dim_modal = true,
		-- dim_inactive = false,
		-- dim_strength = 0.3,
		-- dim_special = 0.2,
		-- dim_around = 0.4,
		-- screen_shader = "",
		-- border_part_of_window = true,

		blur = {
			enabled = false,
			size = 20,
			passes = 1,
			-- ignore_opacity = false,
			-- new_optimizations = true,
			-- xray = false,
			-- noise = 0.015,
			-- contrast = 1.05,
			-- brightness = 1.0,
			-- vibrancy = 0.25,
			-- vibrancy_darkness = 0.15,
			-- special = true,
			popups = true,
			popups_ignorealpha = 0,
			-- input_methods = true,
			-- input_methods_ignorealpha = 0.1,
		},

		shadow = {
			enabled = false,
			-- range = 16,
			-- render_power = 4,
			-- sharp = false,
			-- color = "0x99000000",
			-- color_inactive = "0x66000000",
			-- offset = { 0, 6 },
			-- scale = 1.15,
		},

		glow = {
			enabled = false,
			-- range = 14,
			-- render_power = 3,
			-- color = "0x55" .. colors.color13:sub(2),
			-- color_inactive = "0x22" .. colors.color11:sub(2),
		},

		motion_blur = {
			enabled = false,
			-- samples = 7,
		},
	},
})
