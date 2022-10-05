local Element = require "UIElement"
local Text = Element:new();

function Text:new()
    local element = Element:new()

    element.data = {
        ["Text"] = ""
    }

    setmetatable(element, self)
    self.__index = self

    return element
end

function Text:drawThis()
    local pos = self:getWorldPos()

    love.graphics.setColor(0, 0, 0)

    love.graphics.print(self.data.Text, pos.x, pos.y)

    love.graphics.setColor(1, 1, 1)
end

return Text