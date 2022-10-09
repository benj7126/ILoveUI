local Element = require "UIElement"
local TreeSegment = Element:new();

function TreeSegment:new()
    local element = Element:new()

    element.data["IncrementX"] = 0
    element.data["IncrementY"] = 0
    
    element.data["mainChild"] = nil

    element.data.Size = Vector:new(0, 0)
    
    element.name = "TreeSegment"

    setmetatable(element, self)
    self.__index = self

    return element
end

function TreeSegment:draw()
    if not self.isActive then return end
    if not self.isVisible then return end

    local totalIncrementX = 0
    local totalIncrementY = 0

    if self.data.mainChild then
        local addIncrementY = self.data.IncrementY
        local addIncrementX = self.data.IncrementX
        local child = self.data.mainChild

        child:draw()
        if child.data.Size then
            totalIncrementY = totalIncrementY + child.data.Size.y
        end
        
        love.graphics.translate(addIncrementX, addIncrementY)
        totalIncrementX = totalIncrementX + self.data.IncrementX
        totalIncrementY = totalIncrementY + self.data.IncrementY
    end

    for i, v in pairs(self:getChildPriorityList()) do
        local addIncrementY = self.data.IncrementY
        local addIncrementX = 0

        v:draw()
        if v.data.Size then
            addIncrementY = addIncrementY + v.data.Size.y
        end

        love.graphics.translate(addIncrementX, addIncrementY)
        totalIncrementX = totalIncrementX + addIncrementX
        totalIncrementY = totalIncrementY + addIncrementY
    end

    self.data.Size = Vector:new(totalIncrementX, totalIncrementY)
    
    love.graphics.translate(-totalIncrementX, -totalIncrementY)
end

function TreeSegment:setMainChild(element)
    self.data.mainChild = element
end

function TreeSegment:eventChain(name, x, y, ...)
    if not self.isActive then return end
    if not self:allowEvent(name) then return end
    
    if self[name] then
        self[name](self, ...)
    end
    if name == "mousepressed" or name == "mousemoved" or name == "mousereleased" then
        local totalIncrementX = 0
        local totalIncrementY = 0

        if self.data.mainChild then
            local addIncrementY = self.data.IncrementY
            local addIncrementX = self.data.IncrementX
            local child = self.data.mainChild

            if child.data.Size then
                totalIncrementY = totalIncrementY + child.data.Size.y
            end
            
            child:eventChain(name, x-totalIncrementX, y-totalIncrementY, ...)
            totalIncrementX = totalIncrementX + self.data.IncrementX
            totalIncrementY = totalIncrementY + self.data.IncrementY
        end

        for i, v in pairs(self:getChildPriorityList()) do
            local addIncrementY = self.data.IncrementY
            local addIncrementX = 0

            if v.data.Size then
                addIncrementY = addIncrementY + v.data.Size.y
            end

            v:eventChain(name, x-totalIncrementX, y-totalIncrementY, ...)
            totalIncrementX = totalIncrementX + addIncrementX
            totalIncrementY = totalIncrementY + addIncrementY
        end
    
    else
        for i, v in pairs(self.children) do
            i:eventChain(name, ...)
        end
    end
end

return TreeSegment