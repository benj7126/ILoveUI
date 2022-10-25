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
        local pos = self:getWorldPosition()
        love.graphics.translate(pos.x, pos.y)
        self.drawCall()
        love.graphics.translate(-pos.x, -pos.y)
    end

    if self[name] then
        self[name](self, ...)
    end
    
    for i, v in ipairs(self:getSortedSubElementList()) do
        v:passCall(name, ...)
    end

    for i, v in ipairs(self:getSortedChildList()) do
        v:passCall(name, ...)
    end
end

return DrawElement