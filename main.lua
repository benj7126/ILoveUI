local C = require "ILoveUI.UIController" :new()

function love.draw()
    C.Element:passCall("draw")
end