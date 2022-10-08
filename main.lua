local Controller = require("controller")("UI.lua")

Controller:setKeyValue("window", "DrawCall", function ()
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, 1920, 1080)
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