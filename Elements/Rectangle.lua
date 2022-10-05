local Element = require "UIElement"
local Rectangle = Element:new();

function Rectangle:new()
    local element = Element:new()

    element.data = {
        ["Width"] = 0,
        ["Height"] = 0
    }

    setmetatable(element, self)
    self.__index = self

    return element
end

function Rectangle:drawThis()
    local pos = self:getWorldPos()

    love.graphics.rectangle("fill", pos.x, pos.y, self.data.Width, self.data.Height)
end

return Rectangle