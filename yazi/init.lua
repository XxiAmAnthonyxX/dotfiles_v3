-- ~/.config/yazi/init.lua

-- Full border (cleaner panes)
require("full-border"):setup({
	type = ui.Border.ROUNDED,
})

-- Feed directories you browse into zoxide's database
require("zoxide"):setup({
	update_db = true,
})

-- Cross-instance yank (copy in one Yazi, paste in another)
require("session"):setup({
	sync_yanked = true,
})

-- Custom linemode: size + mtime (referenced by linemode = "size_and_mtime")
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
