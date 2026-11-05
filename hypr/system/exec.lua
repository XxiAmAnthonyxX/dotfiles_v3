hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	hl.exec_cmd("wl-clip-persist --clipboard regular")
	hl.exec_cmd("wl-paste --type text  --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")

	hl.exec_cmd("hyprpm reload")

	hl.exec_cmd("udiskie")

	hl.exec_cmd("qs -c bar")
	hl.exec_cmd("qs -c clipboard")
	hl.exec_cmd("qs -c launcher")
	hl.exec_cmd("qs -c screenshot")
	hl.exec_cmd("qs -c wallpaper")
end)
