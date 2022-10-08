local Controller = require("controller")("UI.lua")

local myController = require("ElementController"):new()
local Base=myController.allElements.UIElement:new()
myController.base = Base;

local selectedElement = Base

Controller:setKeyValue("window", "DrawCall", function ()
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.rectangle("fill", 0, 0, 1920/2, 1080)
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