package.path = package.path .. ";./?.lua;./?/init.lua"

local smw = require("plugins.split-monitor-workspaces")
smw.setup({
	workspace_count = 5,
	monitor_priority = { "DP-1", "HDMI-A-1" },
	enable_persistent_workspaces = true,
	enable_wrapping = true,
	keep_focused = true,
})

local mod = "SUPER"

-- ─── Window: close ──────────────────────────────────────────────────────────
hl.bind(mod .. " + ESCAPE", hl.dsp.window.close())

-- ─── Focus (scrolling layout) ───────────────────────────────────────────────
hl.bind(mod .. " + A", hl.dsp.layout("focus l"))
hl.bind(mod .. " + D", hl.dsp.layout("focus r"))
hl.bind(mod .. " + S", hl.dsp.layout("focus d"))
hl.bind(mod .. " + W", hl.dsp.layout("focus u"))

-- ─── Move ───────────────────────────────────────────────────────────────────
hl.bind(mod .. " + SHIFT + A", hl.dsp.layout("swapcol l"))
hl.bind(mod .. " + SHIFT + D", hl.dsp.layout("swapcol r"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + W", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + P", hl.dsp.window.move({ direction = "left" }))

-- ─── Column expand / collapse ───────────────────────────────────────────────
hl.bind(mod .. " + SHIFT + SPACE", function()
	local w = hl.get_active_window()
	if not w then
		return
	end

	local mon = w.monitor
	if not mon then
		return
	end

	local win_w = w.size and (w.size.x or w.size[1]) or w.width
	local mon_w = mon.size and (mon.size.x or mon.size[1]) or mon.width
	if not win_w or not mon_w or mon_w == 0 then
		return
	end

	local frac = win_w / mon_w
	if frac >= 0.90 then
		hl.dispatch(hl.dsp.layout("colresize 0.5"))
	else
		hl.dispatch(hl.dsp.layout("colresize 1.0"))
	end
end)

-- ─── Float / fullscreen ─────────────────────────────────────────────────────
hl.bind(mod .. " + SHIFT + TAB", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + CTRL + SPACE", hl.dsp.window.fullscreen({ action = "toggle" }))

-- ─── Mouse ──────────────────────────────────────────────────────────────────
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ─── Workspaces (split-monitor-workspaces) ──────────────────────────────────
for i = 1, smw.get_amount_of_workspaces() do
	local n = tostring(i)
	hl.bind(mod .. " + " .. n, smw.workspace(n))
	hl.bind(mod .. " + SHIFT + " .. n, smw.move_to_workspace(n))
	hl.bind(mod .. " + CTRL + " .. n, smw.move_to_workspace_silent(n))
end

-- ─── Apps ───────────────────────────────────────────────────────────────────
hl.bind(mod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("kitty -e yazi")) -- file manager
hl.bind(mod .. " + X", hl.dsp.exec_cmd("librewolf"))
hl.bind(mod .. " + Z", hl.dsp.exec_cmd("steam"))

-- ─── Quickshell overlays (multi-config: qs -c <name>) ───────────────────────
-- Matches bar ActionButtons: clipboard, launcher, lock, screenshot, wallpaper
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("qs -c launcher ipc call launcher toggle"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("qs -c clipboard ipc call clipboard open"))
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("qs -c wallpaper ipc call wallpaper open"))
hl.bind(mod .. " + P", hl.dsp.exec_cmd("qs -c screenshot ipc call screenshot open"))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("qs -c lock"))

-- ─── Media (playerctl) ──────────────────────────────────────────────────────
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))

-- Optional: same actions without media keys
hl.bind(mod .. " + CTRL + P", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mod .. " + CTRL + RIGHT", hl.dsp.exec_cmd("playerctl next"))
hl.bind(mod .. " + CTRL + LEFT", hl.dsp.exec_cmd("playerctl previous"))

-- ─── Volume (wireplumber / wpctl) ───────────────────────────────────────────
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

-- ─── Power ──────────────────────────────────────────────────────────────────
hl.bind(mod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd("systemctl poweroff"))
hl.bind(mod .. " + CTRL + ESCAPE", hl.dsp.exec_cmd("systemctl reboot"))
-- Exit Hyprland session (logout)
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl dispatch exit"))

-- ─── Scroll overview plugin ─────────────────────────────────────────────────
hl.config({
	plugin = {
		scrolloverview = {
			gesture_distance = 300,
			scale = 0.5,
			workspace_gap = 100,
			layout = "vertical",
			wallpaper = 2,
			blur = true,
			shadow = {
				enabled = true,
				range = 50,
			},
		},
	},
})

hl.bind(mod .. " + G", function()
	hl.plugin.scrolloverview.overview("toggle all")
end)
