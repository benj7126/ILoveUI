local EL = require("ILoveUI.Element")
local Image = EL:new()

function Image:new()
    local element = EL:new()

    element.color = {1, 1, 1, 1}
    element.image = ""
    
    element.rotation = 0

    element.scale = Vector:new(1, 1)
    element.origin = Vector:new()
    element.shearing = Vector:new()

    setmetatable(element, self)
    self.__index = self

    return element
end

function Image:draw()
    if self.image == "" then return end

    local pos = self:getWorldPosition()
    local C = self:getC()
    love.graphics.setColor(self.color)
    love.graphics.draw(C:getImage(self.image), pos.x, pos.y, self.rotation, self.scale.x, self.scale.y, self.origin.x, self.origin.y, self.shearing.x, self.shearing.y)
end

return Image