local base = require "controller"

local but = require("Elements.Button"):new()
but.data.Size = Vector:new(100, 100)
but.data.OnClickHook = function ()
    but.data.Size.x = but.data.Size.x + 10
end
but:setParent(base)

local txt = require("Elements.Text"):new()
txt.data.Text = "Hello there, how you doing there, did you see me... yeah?"
txt:setParent(but)

--[[

scorll - element that can scroll up and down, has a stencil border (like scale)
list - just a list of things (so an array, that turns to visuals shit), then you can place it into a scroll element
label - text you can click on to write on

]]--