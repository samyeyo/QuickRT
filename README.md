<div align="center">

# QuickRT

[![Made with LuaRT](https://badgen.net/badge/Made%20with/LuaRT/yellow)](https://www.luart.org/)
![Windows](https://badgen.net/badge/Windows/Vista%20and%20later/blue?icon=windows)
[![QuickRT license](https://badgen.net/badge/License/MIT/green)](#)

QuickRT is a Lua console REPL that allows you to easily prototype, test, and learn Lua programming with LuaRT, the Windows programming framework.

[Features](#features) |
[Getting started](#getting-started) |
[Installation](#installation) 

![Demo][demo] 
</div>

## Features

- Lua 5.4 interactive REPL (Read-Print-Eval-Loop)
- Lua colored syntax highlighting.
- Multiline editing with indentation.
- Autocompletion.
- Command history.
- LuaRT documentation included.
- UTF8 characters support.

## Installation

### Running QuickRT from sources
[LuaRT](https://www.luart.org) must have been previously installed. Doubleclick on the quickrt.lua  file in the Windows explorer to launch QuickRT.

Alternatively, open a LuaRT console and go to the directory where you've downloaded QuickRT source files.
Then type the following command :

```batch
luart quickrt.lua
```
### Running QuickRT from release package
No need to previously install LuaRT with the compiled release package.
Go to the folder where you have extracted QuickRT.exe and doubleclick on it in the Windows explorer.

## Getting started

To get you started with QuickRT, type the following commands :

```lua
help("topic")      -- search help for "topic"
clear()            -- clears the screen
a                  -- shows the value of variable 'a'
5+5                -- shows the result of 5+5
print("hello")     -- calls a function and shows its result
pr                 -- type "pr" then press the TAB key to use autocompletion (should find 'print')
```

You can use last entered commands by pressing the &#8593; and &#8595; keys.

[demo]: contrib/QuickRT.webp
