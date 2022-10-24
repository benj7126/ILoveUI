local EL = require("ILoveUI.Elements.Button")
local Button = EL:new()

function Button:new()
    local element = EL:new()

    setmetatable(element, self)
    self.__index = self

    self.img = element:addSubElement("ILoveUI.Elements.Image")
    self.img:linkVarToParent("size")

    return element
end

return Button