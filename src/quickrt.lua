-- | LuaRT - A Windows programming framework for Lua
-- | Luart.org, Copyright (c) Tine Samir 2022.
-- | See Copyright Notice in LICENSE.TXT
-- |------------------------------------------------
-- | QuickRT.lua | Powerful REPL for LuaRT




local console = require 'console'
require "readline"
local indent = require "indent"
local pretty = require "pretty"

console.title = "QuickRT - REPL for LuaRT"
console.font = "consolas"

-- clear command : clears the screen
function clear()
	console.clear()
end

-- help command : provides help on the specified topic
help = require "help"

-- Welcome message 
console.clear()
console.writecolor("lightblue", string.char(0xE2, 0x95, 0xAD))
console.writecolor("lightblue", string.rep(string.char(0xE2, 0x94, 0x81), 36)..string.char(0xE2, 0x95, 0xAE).."\n")
console.writecolor("lightblue", string.char(0xE2, 0x94, 0x82).. " ")
console.writecolor("lightblue", "Quick")
console.writecolor("blue", "RT")
console.write(" - Powerful REPL for ")
console.writecolor("brightwhite", "Lua")
console.writecolor('yellow', "RT ")
console.writecolor("blue", " "..string.char(0xE2, 0x94, 0x82).."\n")
console.writecolor("lightblue", string.char(0xE2, 0x94, 0x82).." ")
console.write("Copyright "..string.char(0xC2, 0xA9).." 2022, Samir Tine       ")
console.writecolor("blue", string.char(0xE2, 0x94, 0x82),"\n")
console.writecolor("blue", string.char(0xE2, 0x95, 0xB0)..string.rep(string.char(0xE2, 0x94, 0x81), 36)..string.char(0xE2, 0x95, 0xAF).."\n")

-- Environment for Lua commands
env = { console = console }
setmetatable(env, { __index = function(t, key)
						return _G[key]
					end})

local function print_result(val, ch)
	console.writecolor('gray', highlight(pretty(val)..ch))
end
			
-- Read Eval Print Loop : REPL
while true do
	console.write("\n")
	-- Read
	local cmd = indent(readline(nil, env))
	if cmd ~= "" then
		local var = cmd:match("^([%a%s]+)$") or false
		if var then
			print_result(env[var], "\n")
		else
			-- Eval
      local is_expr = false
			local func, err = load("return "..cmd, nil, nil, env)	
			if func == fail then
				func, err = load(cmd, nil, nil, env)
        is_expr = true
			end	
			if func ~= fail then
				local results = table.pack(pcall(func, true))
				if results[1] == true then
					if #results > 1 then
						for i = 2, #results do
							print_result(results[i], " ")
						end
						console.write("\n")
         			elseif is_expr then
            			print_result(nil, "\n")
					end
				else
					console.writecolor("lightred", ">>> "..results[2]:gsub("^%[.*%d%: ", "").."\n")				
				end
			else
				console.writecolor("lightred", ">>> "..err:gsub("^%[.*%d%: ", "").."\n")				
			end
		end
	end
-- Loop
end
	