local Element = require "UIElement"
local ScaleElement = Element:new()

function ScaleElement:new()
    local element = Element:new()
    
    element.data["Size"] = Vector:new(0, 0)
    element.data["TargetSize"] = Vector:new(0, 0)
    
    setmetatable(element, self)
    self.__index = self

    return element
end

function ScaleElement:draw()
    local pos = self:getWorldPos()
    local size = self.data.Size
    local targetSize = self.data.TargetSize

    if targetSize.x == 0 or targetSize.y == 0 then return end

    local scaleX, scaleY = size.x/targetSize.x, size.y/targetSize.y

    love.graphics.stencil(function () love.graphics.rectangle("fill", pos.x, pos.y, size.x, size.y) end, "replace", 1)
    
    love.graphics.setStencilTest("greater", 0)

    love.graphics.scale(scaleX, scaleY)

    for i, v in pairs(self.children) do
        i:draw()
    end

    love.graphics.setStencilTest()

    love.graphics.scale(1/scaleX, 1/scaleY)
end

return ScaleElement