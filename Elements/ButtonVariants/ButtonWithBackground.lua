local EL = require("ILoveUI.Elements.Button")
local Button = EL:new()

function Button:new()
    local element = EL:new()

    setmetatable(element, self)
    self.__index = self

    element.rec = element:addSubElement("ILoveUI.Elements.Figures.Rectangle")
    element.rec:linkVarToParent("size")

    return element
end

return Button