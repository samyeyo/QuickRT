-- | LuaRT - A Windows programming framework for Lua
-- | Luart.org, Copyright (c) Tine Samir 2022.
-- | See Copyright Notice in LICENSE.TXT
-- |------------------------------------------------
-- | readline.lua | Command line management




local console = require "console"
local highlight = require "highlighter"

local history = {}

local function readline(prompt)
	local isend = false
	if prompt ~= nil then
		console.writecolor("blue", prompt)
        console.writecolor("gray", "end")
        console.x = console.x - 2
		isend = true
	else
		prompt =  string.char(13, 0xE2, 0x96, 0xBA, 32)
		console.writecolor("blue", prompt)
	end
	local str = str or ""
	local pos = console.x
	local history_index = #history
	local tab_index = 0
	local tab_pos
	local tab_list = {}
	while (true) do 
		local c, special = console.readchar()
		if not special then
			if c == "\r" then
				if isend and str == "" then
					str = "end"
				end
				console.write(c)
				console.writecolor("blue", prompt)
				highlight(str.."\n")
				history[#history+1] = str
				history_index = #history
				return str
			elseif c == "\t" then
				if tab_index == 0 then
					local word = str:match("(%w+)$") or false
					if word then
						for k, v in pairs(_G) do
							if k:match("^"..word) then
								tab_list[#tab_list+1] = k
							end
						end
						tab_index = tab_list[1] ~= nil and 1 or 0
						tab_pos = #str-#word
					end
				end
				if tab_index > 0 then
					local tabitem = tab_list[tab_index]
					local lastpos = console.x
					console.x = pos+tab_pos+1
					console.write(string.rep(" ", #str-tab_pos+1))
					str = str:sub(1, tab_pos)
					console.x = tab_pos + pos + 1
					str = str..tabitem
					console.writecolor(type(_G[tabitem]) == "function" and "lightyellow" or "white", tabitem)
					tab_index = tab_index == #tab_list and 1 or (tab_index + 1)
					goto continue
				end
			elseif c == "\b" then
				if console.x > pos then
					console.write("\b \b")
					str = str:sub(1, -2)
					tab_index = 0
					tab_list = {}
				end
			elseif c == '\3' then
				sys.exit()
			else
				console.write(c)
				str = str..c
			end
		elseif c == "H" then
			if history_index > 0 then
				console.x = pos + 1
				str = history[history_index]
				history_index = history_index - 1
				if history_index == 0 then
					history_index = 1
				end
				console.write(string.rep(" ", console.width - console.x-1))
				console.x = pos + 1
				console.write(str)
				console.x = pos + 1 + #str
			end
		elseif c == "P" then
			if history_index < #history then
				console.x = pos + 1
				history_index = history_index + 1
				str = history[history_index]
				if history_index == #history then
					history_index = #history-1
				end
				console.write(string.rep(" ", console.width - console.x-1))
				console.x = pos + 1
				console.write(str)
				console.x = pos + 1 + #str
			end
		end
		tab_index = 0
		tab_list = {}
::continue::
	end
end

return readline