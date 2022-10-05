local Rectangle = require("Elements.Rectangle")
local Button = Rectangle:new()

function Button:new()
    local element = Rectangle:new()

    element.data["OnClickHook"] = function () end

    setmetatable(element, self)
    self.__index = self

    return element
end

function Button:mousepressed(x, y, b)
    local pos = self:getWorldPos()
    local size = self.data.Size

    if x > pos.x and x < pos.x + size.x and y > pos.y and y < pos.y + size.y then
        self.data.OnClickHook()
    end
end

return Button