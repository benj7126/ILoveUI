local Element = require "UIElement"
local ElementList = Element:new();

function ElementList:new()
    local element = Element:new()

    element.data["AutoAddIncrement"] = true
    element.data["Increment"] = 0
    
    element.name = "ElementList"

    setmetatable(element, self)
    self.__index = self

    return element
end

function ElementList:draw()
    local totalIncrement = 0

    for i, v in pairs(self.children) do
        local addIncrement = self.data.Increment

        if self.data.AutoAddIncrement then
            if i.data.Size then
                addIncrement = addIncrement + i.data.Size.y
            end
        end

        i:draw()
        love.graphics.translate(0, addIncrement)
        totalIncrement = totalIncrement + addIncrement
    end
    
    love.graphics.translate(0, -totalIncrement)
end

return ElementList