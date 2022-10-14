local EL = require("ILoveUI.Elements.Figure")
local Circle = EL:new()

function Circle:new()
    local element = EL:new()

    element.size = 10

    setmetatable(element, self)
    self.__index = self

    return element
end

function Circle:draw()
    local pos = self:getWorldPosition()
    love.graphics.setColor(self.color)
    love.graphics.circle(self.mode, pos.x, pos.y, self.size)
end

return Circle