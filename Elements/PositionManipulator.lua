local EL = require("ILoveUI.Element")
local Offsetter = EL:new()

function Offsetter:new()
    local element = EL:new()
    
    element.offset = Vector:new()
    element.wrapOffset = Vector:new()
    element.wrapAt = 0;

    setmetatable(element, self)
    self.__index = self

    return element
end

function Offsetter:getAditionalOffset(child)
    local childrenInOrder = self:getSortedChildList()

    for i, v in ipairs(childrenInOrder) do
        if v == child then
            return self:doOffsetCalculations(i)
        end
    end

    return Vector:new()
end

function Offsetter:doOffsetCalculations(index)
    index = index - 1
    if self.wrapAt ~= 0 then
        local x = (index%self.wrapAt)
        local y = (index-x)/self.wrapAt
    
        return self.offset*x+self.wrapOffset*y
    else
        return self.offset*index
    end
end

return Offsetter