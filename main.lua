local Controller = require("controller")("UI")

local hax = 0

Controller:setKeyValue("screen1", "DrawCall", function ()
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", hax, 0, 100, 100)
end)

function love.keypressed(key)
    if key == "a" then
        love.event.push("resize")
        love.window.setFullscreen( not love.window.getFullscreen() )
    elseif key == "d" then
        hax = hax + 10
    end
end