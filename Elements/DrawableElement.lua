local Element = require "UIElement"
local DrawableElement = Element:new();

function DrawableElement:new()
    local element = Element:new()

    element.data["Size"] = Vector:new(0, 0)
    element.data["TargetSize"] = Vector:new(0, 0)
    element.data["AutoTranslate"] = true
    element.data["DrawCall"] = function () end
    
    element.name = "DrawableElement"

    setmetatable(element, self)
    self.__index = self

    return element
end

function DrawableElement:drawThis()
    local pos = self:getWorldPos()
    local size = self.data.Size
    local targetSize = self.data.TargetSize

    if targetSize.x == 0 or targetSize.y == 0 then return end

    local scaleX, scaleY = size.x/targetSize.x, size.y/targetSize.y

    love.graphics.stencil(function () love.graphics.rectangle("fill", 0, 0, size.x, size.y) end, "replace", 1)
    
    love.graphics.setStencilTest("greater", 0)

    if self.data.AutoTranslate then
        love.graphics.translate(pos.x, pos.y)
    end
    
    love.graphics.scale(scaleX, scaleY)

    self.data.DrawCall() -- draw function

    love.graphics.setStencilTest()

    love.graphics.scale(1/scaleX, 1/scaleY)

    if self.data.AutoTranslate then
        love.graphics.translate(-pos.x, -pos.y)
    end
end

return DrawableElement