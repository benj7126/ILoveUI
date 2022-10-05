local Element = require "UIElement"
local ElementList = Element:new();

function ElementList:new()
    local element = Element:new()

    element.data["AutoAddIncrement"] = true
    element.data["IncrementX"] = 0
    element.data["IncrementY"] = 0
    
    element.name = "ElementList"

    setmetatable(element, self)
    self.__index = self

    return element
end

function ElementList:draw()
    local totalIncrementX = 0
    local totalIncrementY = 0

    for i, v in pairs(self.children) do
        local addIncrementY = self.data.IncrementY
        local addIncrementX = self.data.IncrementX

        if self.data.AutoAddIncrement then
            if i.data.Size then
                addIncrementY = addIncrementY + i.data.Size.y
            end
        end

        i:draw()
        love.graphics.translate(addIncrementX, addIncrementY)
        totalIncrementX = totalIncrementX + addIncrementX
        totalIncrementY = totalIncrementY + addIncrementY
    end
    
    love.graphics.translate(-totalIncrementX, -totalIncrementY)
end

return ElementList