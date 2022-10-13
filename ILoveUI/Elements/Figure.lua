local EL = require("ILoveUI.Element")
local Figure = EL:new()

function Figure:new()
    local element = EL:new()

    element.color = {1, 1, 1, 1}
    element.mode = "fill"

    setmetatable(element, self)
    self.__index = self

    return element
end

return Figure