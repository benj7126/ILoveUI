local Element = require "UIElement"
local Empty = Element:new();

function Empty:new()
    local element = Element:new()
    
    element.name = "Empty"

    setmetatable(element, self)
    self.__index = self

    return element
end

return Empty