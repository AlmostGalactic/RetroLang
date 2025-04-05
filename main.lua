-- main.lua
local Interpreter = require("./Interpreter")


local fileName = arg[1]  -- read one line of user input

-- Attempt to open the file
local file = io.open(fileName, "r")
if not file then
    error("Could not open file: " .. fileName)
end

-- Read the entire file contents
local code = file:read("*a")
file:close()

-- 3) Interpret
local interp = Interpreter.new()
interp:interpret(code)
