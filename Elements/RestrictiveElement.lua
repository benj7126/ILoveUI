local Element = require "UIElement"
local RestrictiveElement = Element:new()

function RestrictiveElement:new()
    local element = Element:new()
    
    element.data["Size"] = Vector:new(0, 0)
    element.data["IgnoreOutside"] = true

    element.name = "RestrictiveElement"
    
    setmetatable(element, self)
    self.__index = self

    return element
end

function RestrictiveElement:draw()
    if not self.isActive then return end
    if not self.isVisible then return end

    local pos = self:getWorldPos()

    local stencilFunction = function () love.graphics.rectangle("fill", pos.x, pos.y, self.data.Size.x, self.data.Size.y) end
    love.graphics.stencil(stencilFunction, "increment", 1, true)

    local mode, value = love.graphics.getStencilTest()
    
    love.graphics.setStencilTest("equal", value+1)

    for i, v in pairs(self:getChildPriorityList()) do
        v:draw()
    end

    love.graphics.stencil(stencilFunction, "decrement", 1, true)
    love.graphics.setStencilTest(mode, value)
end

return RestrictiveElement