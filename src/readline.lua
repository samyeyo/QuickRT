-- | LuaRT - A Windows programming framework for Lua
-- | Luart.org, Copyright (c) Tine Samir 2022.
-- | See Copyright Notice in LICENSE.TXT
-- |------------------------------------------------
-- | readline.lua | Command line management




local console = require "console"
local highlight = require "highlighter"

local history = {}

function readline(prompt, env)
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
	local str = ""
	local pos = console.x
	local history_index = #history
	local cursor = 0
	local tab_index = 0
	local tab_pos
	local tab_list = {}
	
	local function insert_char(c)
		str = str:sub(1, cursor)..c..str:sub(cursor+1, -1)
		console.x = pos + 1
		highlight(str)
		cursor = cursor + 1
		console.x = cursor + pos + 1
	end
	
	while (true) do 
		local c, special = console.readchar()
		console.cursor = false
		if not special then
			-- user pressed the RETURN key
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
			-- user pressed the TAB key
			elseif c == "\t" then
				if tab_index == 0 then
					local kind
					local inmember = str:match("[%.%:]+%w*$") ~= nil
					local word = str:match("(%w+)$") or ""
					if inmember then
						kind = str:match("%w+([%.:]+)"..word.."$")
					end
					local where = env[str:match("(%w+)[%.%:]+"..word.."$")]
					if where == nil then
						if inmember then
							goto continue
						else
							for k, v in pairs(_G) do
								if k:match("^"..word) then
									tab_list[#tab_list+1] = k
								end
							end
						end
					end
					if inmember then
						for k, v in pairs(where) do
							if ((kind == ':' and type(v) == "function") or kind == ".") and (word == "" or k:match("^"..word)) then
								tab_list[#tab_list+1] = k
							end
						end
						if kind == "." then
							local mt = getmetatable(where) or {}
							for k, v in pairs(mt.__type or mt.__properties or {}) do
								if word == "" or k:match("^[gs]+et_"..word) then
									tab_list[#tab_list+1] = k:gsub("^[gs]+et_", "")
								end
							end	
						end
					end
					tab_index = tab_list[1] ~= nil and 1 or 0
					tab_pos = str:len()-(inmember and str:match("[%.:](%w*)$"):len() or word:len())
				end
				if tab_index > 0 then
					local tabitem = tab_list[tab_index]
					local lastpos = console.x
					cursor = tab_pos
					console.write(string.rep('\b \b', str:len())) 
					str = str:gsub("(%w+)$", "")
					for ch in each(tabitem) do
						insert_char(ch)
					end
					tab_index = tab_index == #tab_list and 1 or (tab_index + 1)
					goto continue
				end
			-- user pressed the BACK key
			elseif c == "\b" then
				if console.x > pos then
					console.x = pos + 1
					str = str:sub(1, cursor-1)..str:sub(cursor+1, -1)
					highlight(str.." ")
					console.x = cursor + pos
					tab_index = 0
					tab_list = {}
					cursor = cursor - 1
				end
			elseif c ~= "\x1B" then
				insert_char(c)
			end
			console.cursor = true
		else			
			-- user pressed the UP arrow key
			if c == "H" then
				if history_index > 0 then
					console.x = pos + 1
					str = history[history_index]
					history_index = history_index - 1
					if history_index == 0 then
						history_index = 1
					end
					console.write(string.rep(" ", console.width - console.x-1))
					console.x = pos + 1
					highlight(str)
					console.x = pos + 1 + str:len()
					cursor = str:len()
				end
			-- user pressed the DOWN arrow key
			elseif c == "J" then
				if history_index < #history then
					console.x = pos + 1
					history_index = history_index + 1
					str = history[history_index]
					if history_index == #history then
						history_index = #history-1
					end
					console.write(string.rep(" ", console.width - console.x-1))
					console.x = pos + 1
					highlight(str)
					console.x = pos + 1 + str:len()
					cursor = str:len()
				end
			-- user pressed the HOME key
			elseif c == "F" then
				cursor = 0
				console.x = pos + 1 
			-- user pressed the END key
			elseif c == "E" then
				cursor = str:len()
				console.write(string.rep('\b', str:len())) 
				console.x = cursor + pos + 1
			-- user pressed the LEFT arrow key
			elseif c == "G" and cursor > 0 then
				cursor = cursor - 1
				console.x = cursor + pos + 1
			-- user pressed the RIGHT arrow key
			elseif c == "I" and cursor < str:len() then
				cursor = cursor + 1
				console.x = cursor + pos + 1
			end
		end
		tab_index = 0
		tab_list = {}
::continue::
	console.cursor = true
	end
end