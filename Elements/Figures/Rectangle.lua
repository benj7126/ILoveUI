local EL = require("ILoveUI.Elements.Figure")
local Rectangle = EL:new()

function Rectangle:new()
    local element = EL:new()

    element.size = Vector:new()

    setmetatable(element, self)
    self.__index = self

    return element
end

function Rectangle:draw()
    local pos = self:getWorldPosition()
    love.graphics.setColor(self.color)
    love.graphics.rectangle(self.mode, pos.x, pos.y, self.size.x, self.size.y)
end

return Rectangle