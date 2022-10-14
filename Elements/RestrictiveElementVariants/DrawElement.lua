local EL = require("ILoveUI.Elements.RestrictiveElementVariants.ScaleElement")
local DrawElement = EL:new()

function DrawElement:new()
    local element = EL:new()

    element.drawCall = function () print("remember to set draw call") end

    setmetatable(element, self)
    self.__index = self 

    return element
end

function DrawElement:tryCalls(name, ...)
    if name == "draw" then
        self.drawCall()
    end

    if self[name] then
        self[name](self, ...)
    end
    
    for i, v in ipairs(self.subelements) do
        v:passCall(name, ...)
    end

    for i, v in ipairs(self.children) do
        v:passCall(name, ...)
    end
end

function DrawElement:pre_draw(...)
    local pos, scale = self:local_getWorldPosition()
    self.stencilFunction = function () love.graphics.rectangle("fill", pos.x, pos.y, self.size.x*(1/scale.x), self.size.y*(1/scale.y)) end

    local _, value = love.graphics.getStencilTest()
    
    love.graphics.stencil(self.stencilFunction, "increment", 1, true)
    love.graphics.setStencilTest("equal", value+1)
    
    love.graphics.scale(scale.x, scale.y)
    self.lastScale = scale

    print(scale)
    return ...
end

function DrawElement:post_draw(...)
    local _, value = love.graphics.getStencilTest()
    
    love.graphics.stencil(self.stencilFunction, "decrement", 1, true)
    love.graphics.setStencilTest("equal", value-1)
    
    love.graphics.scale(1/self.lastScale.x, 1/self.lastScale.y)
end

return DrawElement