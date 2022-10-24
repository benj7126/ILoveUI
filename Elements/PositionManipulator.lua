local EL = require("ILoveUI.Element")
local Offsetter = EL:new()

function Offsetter:new()
    local element = EL:new()
    
    element.offset = Vector:new()

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
    return self.offset*index
end

return Offsetter