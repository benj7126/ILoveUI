local Base = require "controller"

for i, v in pairs(Base.keys) do print(i, v) end

Base.keys["screen1"].data.DrawCall = function ()
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, 50000, 5000)
end

function love.keypressed(key)
    if key == "a" then
        love.event.push("resize")
        love.window.setFullscreen( not love.window.getFullscreen() )
    end
end