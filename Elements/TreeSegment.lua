local Element = require "UIElement"
local TreeSegment = Element:new();

function TreeSegment:new()
    local element = Element:new()

    element.data["IncrementX"] = 0
    element.data["IncrementY"] = 0
    
    element.data["isOpen"] = true
    
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

    local pos = self:getWorldPos()


    local totalIncrementX = pos.x
    local totalIncrementY = pos.y

    if self.data.mainChild then
        local child = self.data.mainChild
        
        child:draw()
        
        if child.data.Size then
            totalIncrementY = totalIncrementY + child.data.Size.y
        end

        totalIncrementX = totalIncrementX + self.data.IncrementX
        totalIncrementY = totalIncrementY + self.data.IncrementY
    end

    if self.data.isOpen then
        for i, v in pairs(self:getChildPriorityList()) do
            love.graphics.translate(totalIncrementX, totalIncrementY)
            v:draw()
            love.graphics.translate(-totalIncrementX, -totalIncrementY)
            if v.data.Size then
                totalIncrementY = totalIncrementY + v.data.Size.y
            end

            totalIncrementY = totalIncrementY + self.data.IncrementY
        end
    end

    self.data.Size = Vector:new(totalIncrementX, totalIncrementY-self.data.IncrementY)
end

function TreeSegment:setMainChild(element)
    self.data.mainChild = element
end

function TreeSegment:eventChain(name, x, y, ...)
    if not self.isActive then return end
    if not self:allowEvent(name) then return end

    local pos = self:getWorldPos()
    
    if self[name] then
        self[name](self, ...)
    end
    if name == "mousepressed" or name == "mousemoved" or name == "mousereleased" then
        local totalIncrementX = pos.x
        local totalIncrementY = pos.y

        if self.data.mainChild then
            local child = self.data.mainChild
            
            child:eventChain(name, x, y, ...)
        
            if child.data.Size then
                totalIncrementY = totalIncrementY + child.data.Size.y
            end
    
            totalIncrementX = totalIncrementX + self.data.IncrementX
            totalIncrementY = totalIncrementY + self.data.IncrementY
        end

        for i, v in pairs(self:getChildPriorityList()) do
            v:eventChain(name, x-totalIncrementX, y-totalIncrementY, ...)

            if v.data.Size then
                totalIncrementY = totalIncrementY + v.data.Size.y
            end
    
            totalIncrementY = totalIncrementY + self.data.IncrementY
        end
    
    else
        for i, v in pairs(self.children) do
            i:eventChain(name, ...)
        end
    end
end

return TreeSegment