local EL = require("ILoveUI.Elements.RestrictiveElement")
local RestrictiveRec = EL:new()

function RestrictiveRec:new()
    local element = EL:new()

    setmetatable(element, self)
    self.__index = self

    element.rec = element:addSubElement("ILoveUI.Elements.Figures.Rectangle")
    element.rec:linkVarToParent("size")

    return element
end

return RestrictiveRec