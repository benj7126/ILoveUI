local Element = require "UIElement"
local Scroll = Element:new();

function Scroll:new()
    local element = Element:new()

    element.data["Size"] = Vector:new(0, 0)
    
    element.data["CurScroll"] = 0
    element.data["MaxScroll"] = 0
    element.data["MinScroll"] = 0
    
    element.data["Stenscil"] = true
    element.data["CheckBounds"] = true
    
    element.data["ScrollScale"] = -5
    
    element.name = "Scroll"

    setmetatable(element, self)
    self.__index = self

    return element
end

function Scroll:draw()
    if not self.isActive then return end
    if not self.isVisible then return end
    
    if self.data["Stenscil"] == false then
        for i, v in pairs(self.children) do
            i:draw()
        end
        return
    end

    local pos = self:localGetWorldPos()
    local size = self.data.Size
    
    local stencilFunction = function () love.graphics.rectangle("fill", pos.x, pos.y, size.x, size.y) end
    love.graphics.stencil(stencilFunction, "increment", 1, true)

    local mode, value = love.graphics.getStencilTest()
    
    love.graphics.setStencilTest("equal", value+1)

    for i, v in pairs(self:getChildPriorityList()) do
        v:draw()
    end

    love.graphics.stencil(stencilFunction, "decrement", 1, true)
    love.graphics.setStencilTest(mode, value)
end

--[[

    local stencilFunction = function () love.graphics.rectangle("fill", pos.x, pos.y, self.data.Size.x, self.data.Size.y) end
    love.graphics.stencil(stencilFunction, "increment", 1, true)

    local mode, value = love.graphics.getStencilTest()
    
    love.graphics.setStencilTest("equal", value+1)

    for i, v in pairs(self:getChildPriorityList()) do
        v:draw()
    end

    love.graphics.stencil(stencilFunction, "decrement", 1, true)
    love.graphics.setStencilTest(mode, value)

]]

function Scroll:wheelmoved(x, y)
    local pos = self:localGetWorldPos()
    local size = self.data.Size
    if self.data.CheckBounds == true and size.x == 0 and size.y == 0 and self.parent.data.Size then
        size = self.parent.data.Size
    end

    local mx, my = love.mouse.getPosition()
    if self.data["CheckBounds"] == false or (mx > pos.x and mx < pos.x + size.x and my > pos.y and my < pos.y + size.y) then
        self.data.CurScroll = math.min(math.max(self.data.CurScroll + y*self.data.ScrollScale, self.data.MinScroll), self.data.MaxScroll)
    end
end

function Scroll:setMinMax(min, max)
    if min > max then return end

    self.data.MinScroll = min
    self.data.MaxScroll = max
    self.data.CurScroll = math.min(math.max(self.data.CurScroll, self.data.MinScroll), self.data.MaxScroll)
end

function Scroll:getWorldPos()
    local parentPos = Vector:new(0, 0)
    if self.parent then
        parentPos = self.parent:getWorldPos()
    end

    return parentPos+self.pos+Vector:new(0, self.data.CurScroll)
end

function Scroll:localGetWorldPos()
    local parentPos = Vector:new(0, 0)
    if self.parent then
        parentPos = self.parent:getWorldPos()
    end

    return parentPos+self.pos
end

return Scroll