local Element = require "UIElement"
local Text = Element:new()

function Text:new()
    local element = Element:new()

    element.data["Text"] = ""
    element.data["Font"] = love.graphics.newFont()
    element.data["Limit"] = 0
    element.data["Align"] = "left" -- center and right
    
    element.data["Color"] = {0, 0, 0, 1} -- center and right
    
    element.name = "Text"

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

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.data.Color)

    love.graphics.printf(self.data.Text, self.data.Font,
    pos.x, pos.y, limit, self.data.Align)

    love.graphics.setColor(r, g, b, a)
end

return Text