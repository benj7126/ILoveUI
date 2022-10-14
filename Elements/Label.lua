local EL = require("ILoveUI.Element")
local Label = EL:new()

function Label:new()
    local element = EL:new()

    element.color = {1, 1, 1, 1}
    element.text = ""
    
    element.font = ""
    element.fontSize = 12

    element.limit = 1000
    element.align = "left"

    element.rotation = 0

    element.scale = Vector:new(1, 1)
    element.origin = Vector:new()
    element.shearing = Vector:new()

    setmetatable(element, self)
    self.__index = self

    return element
end

function Label:drawText()
    local pos = self:getWorldPosition()
    local C = self:getC()
    love.graphics.setColor(self.color)
    love.graphics.printf(self.text, C:getFont(self.font, self.fontSize), pos.x, pos.y, self.limit, self.align, self.rotation, self.scale.x, self.scale.y, self.origin.x, self.origin.y, self.shearing.x, self.shearing.y)
end

function Label:draw()
    self:drawText()
end

return Label