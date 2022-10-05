require "vector"
local Element = require("UIElement"):new()
local _Rectangle = require("Elements.Rectangle")
local _Text = require("Elements.Text")

local el2 = _Rectangle:new()

local txt = _Text:new()

txt.data.Text = "Hej"

txt.pos = Vector:new(10, 10)

el2.data.Width = 100
el2.data.Height = 100

el2:setParent(Element)

txt:setParent(el2)

function love.draw()
    Element.pos = Element.pos + Vector:new(1, 0)
    Element:draw()
end