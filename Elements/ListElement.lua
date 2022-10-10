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
    if not self.isActive then return end
    if not self.isVisible then return end

    local totalIncrementX = 0
    local totalIncrementY = 0

    for i, v in pairs(self:getChildPriorityList()) do
        local addIncrementY = self.data.IncrementY
        local addIncrementX = self.data.IncrementX
        if self.data.AutoAddIncrement then
            if v.data.Size then
                addIncrementY = addIncrementY + v.data.Size.y
            end
        end

        v:draw()
        love.graphics.translate(addIncrementX, addIncrementY)
        totalIncrementX = totalIncrementX + addIncrementX
        totalIncrementY = totalIncrementY + addIncrementY
    end
    
    love.graphics.translate(-totalIncrementX, -totalIncrementY)
end

function ElementList:calcHeight()
    local totalIncrementY = 0
    for i, v in pairs(self:getChildPriorityList()) do
        local addIncrementY = self.data.IncrementY
        if self.data.AutoAddIncrement then
            if v.data.Size then
                addIncrementY = addIncrementY + v.data.Size.y
            end
        end
        totalIncrementY = totalIncrementY + addIncrementY
    end
    
    return totalIncrementY
end

function ElementList:eventChain(name, x, y, ...)
    if not self.isActive then return end
    if not self:allowEvent(name) then return end
    
    if self[name] then
        self[name](self, ...)
    end
    if name == "mousepressed" or name == "mousemoved" or name == "mousereleased" then
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
        
            i:eventChain(name, x-totalIncrementX, y-totalIncrementY, ...)
            
            totalIncrementX = totalIncrementX + addIncrementX
            totalIncrementY = totalIncrementY + addIncrementY
        end

    else
        for i, v in pairs(self.children) do
            i:eventChain(name, x, y, ...)
        end
    end
end

return ElementList