local Element = require "UIElement"
local DrawableElement = Element:new();

function DrawableElement:new()
    local element = Element:new()

    element.data["Size"] = Vector:new(0, 0)
    element.data["TargetSize"] = Vector:new(0, 0)
    element.data["AutoTranslate"] = true
    element.data["DrawCall"] = function () end
    element.data["Center"] = false

    element.data["KeepRatio"] = true
    
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

    local orgScaleX, orgScaleY = size.x/targetSize.x, size.y/targetSize.y
    local scaleX, scaleY = orgScaleX, orgScaleY

    if self.data.KeepRatio then
        if scaleY < scaleX then scaleX = scaleY else scaleY = scaleX end
    end
    
    if self.data.Center then
        if scaleX < orgScaleX then
            --("a")
            pos = pos + Vector:new((orgScaleX-scaleX)*targetSize.x/2, 0)
        end
        if scaleY < orgScaleY then
            --print("b")
            pos = pos + Vector:new(0, (orgScaleY-scaleY)*targetSize.y/2)
        end
    end
    --print(pos.x, pos.y, targetSize.x*scaleX, targetSize.y*scaleY)

    
    local stencilFunction = function () love.graphics.rectangle("fill", pos.x, pos.y, targetSize.x*scaleX, targetSize.y*scaleY) end
    love.graphics.stencil(stencilFunction, "increment", 1, true)

    local mode, value = love.graphics.getStencilTest()
    
    love.graphics.setStencilTest("equal", value+1)

    if self.data.AutoTranslate then
        love.graphics.translate(pos.x, pos.y)
    end
    
    love.graphics.scale(scaleX, scaleY)

    self.data.DrawCall() -- draw function

    love.graphics.stencil(stencilFunction, "decrement", 1, true)
    love.graphics.setStencilTest(mode, value)

    love.graphics.scale(1/scaleX, 1/scaleY)

    if self.data.AutoTranslate then
        love.graphics.translate(-pos.x, -pos.y)
    end
end

return DrawableElement