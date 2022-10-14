local EL = require("ILoveUI.Elements.Button")
local Button = EL:new()

function Button:new()
    local element = EL:new()

    setmetatable(element, self)
    self.__index = self

    local r = element:addSubElement("ILoveUI.Elements.Image")
    r:linkVarToParent("size")

    return element
end

return Button