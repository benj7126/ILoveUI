local Element = require "UIElement"
local Rectangle = Element:new();

function Rectangle:new()
    local element = Element:new()

    element.data["Color"] = {1, 1, 1, 1}
    element.data["Size"] = Vector:new(0, 0)

    setmetatable(element, self)
    self.__index = self

    return element
end

function Rectangle:drawThis()
    local pos = self:getWorldPos()

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.data.Color)
    love.graphics.rectangle("fill", pos.x, pos.y, self.data.Size.x, self.data.Size.y)
    love.graphics.setColor(r, g, b, a)
end

return Rectangle