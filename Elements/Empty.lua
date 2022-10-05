local Element = require "UIElement"
local Empty = Element:new();

function Empty:new()
    local element = Element:new()

    setmetatable(element, self)
    self.__index = self

    return element
end

return Empty