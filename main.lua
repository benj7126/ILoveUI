local C = require "ILoveUI.UIController" :new()

local DrawElement = require("ILoveUI.Elements.RestrictiveElementVariants.DrawElement"):new()
C:setBaseElement(DrawElement)
DrawElement.size = Vector:new(100, 100)

DrawElement.drawCall = function ()
    love.graphics.rectangle("fill", 0, 0, 100, 100)
end