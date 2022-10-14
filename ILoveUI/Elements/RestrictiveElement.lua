local EL = require("ILoveUI.Element")
local RestrictiveElement = EL:new()

function RestrictiveElement:new()
    local element = EL:new()
    
    element.size = Vector:new()

    element.stencilFunction = nil
    
    element.ignoreOutside = false

    setmetatable(element, self)
    self.__index = self

    return element
end

local function restrictMovement(self, x, y, ...)
    if self.ignoreOutside == false then return false end
    local pos = self:getWorldPosition()
    
    if x > pos.x and x < pos.x+self.size.x and y > pos.y and y < pos.y+self.size.y then
        return false -- dont resstrict movements
    end

    return true
end

RestrictiveElement.ignore_mousepressed = restrictMovement
RestrictiveElement.ignore_mousemoved = restrictMovement
RestrictiveElement.ignore_mousereleased = restrictMovement
RestrictiveElement.ignore_wheelmoved = restrictMovement

function RestrictiveElement:pre_draw(...)
    local pos = self:getWorldPosition()
    self.stencilFunction = function () love.graphics.rectangle("fill", pos.x, pos.y, self.size.x, self.size.y) end

    local _, value = love.graphics.getStencilTest()
    
    love.graphics.stencil(self.stencilFunction, "increment", 1, true)
    love.graphics.setStencilTest("equal", value+1)
    
    return ...
end

function RestrictiveElement:post_draw(...)
    local _, value = love.graphics.getStencilTest()
    
    love.graphics.stencil(self.stencilFunction, "decrement", 1, true)
    love.graphics.setStencilTest("equal", value-1)
end

return RestrictiveElement