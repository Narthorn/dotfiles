-- cut.lua - Cut a slice of video and save it
--
-- Dependencies: dmenu
-- Keybind: Alt+x

options = {
	outdir = "/home/narthorn/stuff/animu",
	opts = "--oautofps",
	aftercut = function(file) return "chromium http://www.narthorn.com/stuff/animu/" .. file end,
}

--- Logging

msg = setmetatable({},{__index = mp.msg})

-- Hook msg.info to display messages to OSD
function msg.info(message)
	mp.osd_message("[cut] " .. message)
	mp.msg.info(message)
end

--- Util

function os.exists(path) return os.rename(path,path) end

function dmenu_prompt(prompt)

	dmenu_command = "dmenu -p '" .. prompt .. "' <&-"

	local handle = io.popen(dmenu_command)
	local input = handle:read()
	local success,_,eno = handle:close()

	if not success then
		msg.warn("Returned " .. eno .. " when executing \"" .. dmenu_command .. "\" !")
		return
	end

	return input
end

--- Hotkey

function catch_frame()

	local nextpos = mp.get_property_native("playback-time")
	msg.debug("Caught frame " .. tostring(nextpos))

	if not firstpos then
		firstpos = nextpos
		msg.info("Start frame set")
		return
	end

	if firstpos == nextpos then
		msg.info("Both frames are the same, ignoring second one")
		return
	end

	msg.info("End frame set")
	local startpos, endpos = math.min(firstpos, nextpos), math.max(firstpos, nextpos)
	firstpos = nil

	cut(startpos, endpos, get_filename())

end

-- Filename, from user input

function get_filename()
	local filename
	repeat

		filename = dmenu_prompt('Filename: ')
		if not filename or filename == "" then return end

	until not os.exists(options.outdir .. "/" .. filename) or dmenu_prompt('Overwrite? (y/N) ') == 'y'

	return filename
end

--- Chop chop

function cut(startpos, endpos, filename)

	if not filename or filename == "" then
		msg.warn("No filename !")
		return
	end

	infile = "\"" .. mp.get_property("path") .. "\""
	outfile = "\"" .. options.outdir .. "/" .. filename .. "\""

	msg.info("Saving " .. os.date("!%X", startpos) .. " to " .. os.date("!%X",endpos) .. " in " .. filename)

	command = "mpv " .. infile
	command = command .. " --start=" .. startpos
	command = command .. " --end=" .. endpos
	command = command .. " -o " .. outfile
	command = command .. " " .. (options.opts or "")
	command = command .. " " .. (mp.get_property_native("mute") and "--no-audio" or "")
	command = command .. " " .. (mp.get_property_native("sub-visibility") and "" or "--sub-visibility=no")
	command = command .. " " .. (options.aftercut and "&& " .. options.aftercut(filename) or "")
	command = command .. " & disown"

	msg.debug(command)
	os.execute(command)

end

--- Bindings

mp.add_key_binding("alt+x", "cut", catch_frame)
