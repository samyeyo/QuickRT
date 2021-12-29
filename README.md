<div align="center">

# QuickRT

![Made with LuaRT](https://badgen.net/badge/Made%20with/LuaRT/yellow)
![Windows](https://badgen.net/badge/Windows/Vista%20and%20later/blue?icon=windows)
![QuickRT license](https://badgen.net/badge/License/MIT/green)

QuickRT is a LuaRT console REPL that lets you test, prototype, and learn very quickly.

[Features](#features) |
[Getting started](#getting-started) |
[Installation](#installation) 

![Demo][demo] 
</div>
## Features

- Old school console interpreter.
- Lua colored syntax highlighting.
- Multiline editing with indentation.
- Autocompletion.
- Command history.
- LuaRT documentation included.
- Support UTF8 characters.

## Installation

[LuaRT](https://www.luart.org) should have been previously installed. Open a LuaRT console and go to the directory where you've downloaded QuickRT source files.
Then type the following command :

```batch
luart quickrt.lua
```

## Getting started

To get you started, type the following commands :

```lua
help("topic")      -- search help for topic
clear()            -- clears the screen
a                  -- shows the value of variable 'a'
5+5                -- shows the result of 5+5
print("hello")     -- calls a function and shows its result
pr                 -- type "pr" then press the TAB key to use autocompletion (should find 'print')
```

You can use last entered commands by pressing the UP and DOWN arrow keys.

[demo]: contrib/QuickRT.webp
