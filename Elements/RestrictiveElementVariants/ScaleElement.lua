local EL = require("ILoveUI.Elements.RestrictiveElement")
local ScaleElement = EL:new()

function ScaleElement:new()
    local element = EL:new()
    
    element.targetSize = Vector:new(0, 0)

    element.center = true
    element.keepRatio = true

    element.lastScale = nil

    setmetatable(element, self)
    self.__index = self

    return element
end

function ScaleElement:local_getWorldPosition() -- (and scale)
    local pos = Vector:new()
    if self.parent then
        pos = self.parent:getWorldPosition()
    end

    pos = pos + self.pos

    local size = self.size
    local targetSize = self.targetSize

    if targetSize.x == 0 or targetSize.y == 0 then return pos, Vector:new(1, 1) end

    local orgScaleX, orgScaleY = size.x/targetSize.x, size.y/targetSize.y
    local scaleX, scaleY = orgScaleX, orgScaleY

    if scaleY < scaleX then scaleX = scaleY else scaleY = scaleX end

    if self.center and self.keepRatio then
        if scaleX < orgScaleX then
            pos = pos + Vector:new((1-(scaleX/orgScaleX))*size.x/2, 0)
        end
        if scaleY < orgScaleY then
            pos = pos + Vector:new(0, (1-(scaleY/orgScaleY))*size.y/2)
        end
    end
    --print(pos, self.center)

    if self.keepRatio then
        return pos, Vector:new(scaleX, scaleY)
    else
        return pos, Vector:new(orgScaleX, orgScaleY)
    end
end

function ScaleElement:getWorldPosition() -- (and scale)
    local pos, scale = self:local_getWorldPosition();
    return Vector:new(pos.x*(1/scale.x), pos.y*(1/scale.y))
end

local function ModifyMouseEvents(self, x, y, ...)
    local pos, scale = self:local_getWorldPosition()
    return x*(1/scale.x), y*(1/scale.y), ...
end

ScaleElement.pre_mousepressed = ModifyMouseEvents
ScaleElement.pre_mousereleased = ModifyMouseEvents
ScaleElement.pre_wheelmoved = ModifyMouseEvents

function ScaleElement:pre_mousemoved(x, y, mx, my, ...)
    local pos, scale = self:local_getWorldPosition()
    return x*(1/scale.x), y*(1/scale.y), mx*(1/scale.x), my*(1/scale.y), ...
end

function ScaleElement:pre_draw(...)
    local pos, scale = self:local_getWorldPosition()
    self.stencilFunction = function () love.graphics.rectangle("fill", pos.x, pos.y, self.size.x, self.size.y) end

    local mode, value = love.graphics.getStencilTest()
    
    love.graphics.stencil(self.stencilFunction, "increment", 1, true)
    love.graphics.setStencilTest("equal", value+1)
    
    love.graphics.scale(scale.x, scale.y)
    self.lastScale = {mode, value, scale}

    -- print(scale)
    return ...
end

function ScaleElement:post_draw(...)
    local mode, value, scale = self.lastScale[1], self.lastScale[2], self.lastScale[3]
    
    love.graphics.scale(1/scale.x, 1/scale.y)

    love.graphics.stencil(self.stencilFunction, "decrement", 1, true)
    love.graphics.setStencilTest(mode, value)
end

return ScaleElement