local Element = require "UIElement"
local ScaleElement = Element:new()

function ScaleElement:new()
    local element = Element:new()
    
    element.data["Size"] = Vector:new(0, 0)
    element.data["TargetSize"] = Vector:new(0, 0)
    
    element.data["AutoUpdateSize"] = false

    element.data["Center"] = true
    element.data["IgnoreOutside"] = true
    
    element.data["KeepRatio"] = true
    
    element.name = "ScaleElement"
    
    setmetatable(element, self)
    self.__index = self

    return element
end

function ScaleElement:draw()
    if not self.isActive then return end
    if not self.isVisible then return end

    local pos = self:localGetWorldPos()
    local size = self.data.Size
    local targetSize = self.data.TargetSize

    if targetSize.x == 0 or targetSize.y == 0 then return end

    local orgScaleX, orgScaleY = size.x/targetSize.x, size.y/targetSize.y
    local scaleX, scaleY = orgScaleX, orgScaleY

    if self.data.KeepRatio then
        if scaleY < scaleX then scaleX = scaleY else scaleY = scaleX end
    end
    
    if self.data.Center then
        if scaleX < orgScaleX then
            pos = pos + Vector:new((orgScaleX-scaleX)*targetSize.x/2, 0)
        end
        if scaleY < orgScaleY then
            pos = pos + Vector:new(0, (orgScaleY-scaleY)*targetSize.y/2)
        end
    end

    local stencilFunction = function () love.graphics.rectangle("fill", pos.x, pos.y, targetSize.x*scaleX, targetSize.y*scaleY) end
    love.graphics.stencil(stencilFunction, "increment", 1, true)

    local mode, value = love.graphics.getStencilTest()
    
    love.graphics.setStencilTest("equal", value+1)

    local posDiff = pos - self:localGetWorldPos()
    love.graphics.translate(posDiff.x, posDiff.y)
    love.graphics.scale(scaleX, scaleY)

    for i, v in pairs(self:getChildPriorityList()) do
        v:draw()
    end

    love.graphics.stencil(stencilFunction, "decrement", 1, true)
    love.graphics.setStencilTest(mode, value)

    love.graphics.scale(1/scaleX, 1/scaleY)
    love.graphics.translate(-posDiff.x, -posDiff.y)
end

function ScaleElement:getWorldPos()
    local parentPos = Vector:new(0, 0)
    if self.parent then
        parentPos = self.parent:getWorldPos()
    end

    return parentPos+self.pos
end

function ScaleElement:localGetWorldPos()
    local parentPos = Vector:new(0, 0)
    if self.parent then
        parentPos = self.parent:getWorldPos()
    end

    return parentPos+self.pos
end

function ScaleElement:eventChain(name, x, y, ...)
    if not self.isActive then return end
    if not self:allowEvent(name) then return end
    
    if self[name] then
        self[name](self, ...)
    end
    if name == "mousepressed" or name == "mousemoved" or name == "mousereleased" then
        local pos = self:localGetWorldPos()
        local size = self.data.Size
        local targetSize = self.data.TargetSize
    
        if targetSize.x == 0 or targetSize.y == 0 then return end
    
        local orgScaleX, orgScaleY = size.x/targetSize.x, size.y/targetSize.y
        local scaleX, scaleY = orgScaleX, orgScaleY
    
        if scaleY < scaleX then scaleX = scaleY else scaleY = scaleX end
    
        if self.data.Center then
            if scaleX < orgScaleX then
                pos = pos + Vector:new((orgScaleX-scaleX)*targetSize.x/2, 0)
            end
            if scaleY < orgScaleY then
                pos = pos + Vector:new(0, (orgScaleY-scaleY)*targetSize.y/2)
            end
        end

        local posDiff = pos - self:localGetWorldPos()

        local finalPos = Vector:new((x-posDiff.x)*(1/scaleX), (y-posDiff.y)*(1/scaleY));

        if (finalPos.x > 0 and finalPos.x < targetSize.x and finalPos.y > 0 and finalPos.y < targetSize.y) or self.data.IgnoreOutside == false then
            for i, v in pairs(self.children) do
                i:eventChain(name, (x-posDiff.x)*(1/scaleX), (y-posDiff.y)*(1/scaleY), ...)
            end
        end
    else
        for i, v in pairs(self.children) do
            i:eventChain(name, ...)
        end
    end
end

return ScaleElement