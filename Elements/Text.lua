local Element = require "UIElement"
local Text = Element:new()

function Text:new()
    local element = Element:new()

    element.data["Text"] = ""
    element.data["Font"] = love.graphics.newFont()
    element.data["Limit"] = 0
    element.data["Align"] = "left" -- center and right

    setmetatable(element, self)
    self.__index = self

    return element
end

function Text:drawThis()
    local pos = self:getWorldPos()

    local limit = self.data.Limit
    if limit == 0 and self.parent.data.Size then
        limit = self.parent.data.Size.x
    end

    love.graphics.setColor(0, 0, 0)

    love.graphics.printf(self.data.Text, self.data.Font,
    pos.x, pos.y, limit, self.data.Align)

    love.graphics.setColor(1, 1, 1)
end

return Text