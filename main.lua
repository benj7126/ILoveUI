local Controller = require("controller")("UI.lua")

local myController = require("ElementController"):new()
local Base=modifyElement(myController.allElements.UIElement:new());
myController.base = Base;

local selectedElement = nil

Controller:setKeyValue("window", "DrawCall", function ()
    myController:draw()
end)

function love.keypressed(key)
    if key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())

        local w, h = love.graphics.getWidth(), love.graphics.getHeight()
        Controller.keys["scalewindow"].data.Size = Vector:new(w, h)
    elseif key == "u" then
        Controller.keys["UI"].isActive = not Controller.keys["UI"].isActive
    end
end