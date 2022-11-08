local EL = require("ILoveUI.Element")
local ScrollElement = EL:new()

function ScrollElement:new()
    local element = EL:new()
    
    element.offset = Vector:new()
    element.swapScrollAxes = false

    element.onlyWithinTopElement = true

    element.scaleY = 3
    element.scaleX = 0

    element.maxScrollX = 0
    element.minScrollX = 0

    element.maxScrollY = 0
    element.minScrollY = 0

    setmetatable(element, self)
    self.__index = self

    return element
end

function ScrollElement:wheelmoved(x, y, ...)
    local mPos = self:getMousePosition()-self.offset

    print(x, y)
    
    x = x * self.scaleX
    y = y * self.scaleY
    if self.swapScrollAxes then local saveX = x; x = y; y = saveX; end
    self.offset.x = math.min(math.max(self.offset.x + x, self.minScrollX), self.maxScrollX)
    self.offset.y = math.min(math.max(self.offset.y + y, self.minScrollY), self.maxScrollY)

    --print(self.offset)
end

function ScrollElement:getMousePosition()
    local pos;
    if self.parent then
        pos = self.parent:getMousePosition()
    else
        local x, y = love.mouse.getPosition()
        pos = Vector:new(x, y)
    end

    return pos + self.offset
end

function ScrollElement:getWorldPosition()
    local pos = Vector:new()

    if self.parent then
        pos = self.parent:getWorldPosition()
        if self.parent.getAditionalOffset then
            pos = pos + self.parent:getAditionalOffset(self)
        end
    end

    pos = pos + self.pos + self.offset

    return pos
end

return ScrollElement