local Rectangle = require "ILoveUI.Element" :new()

function Rectangle:new(o)
    local element = o or {}

    element.size = Vector:new()

    setmetatable(element, self)
    self.__index = self

    element:require "ILoveUI.Element"

    return element
end

function Rectangle:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
end

return Rectangle