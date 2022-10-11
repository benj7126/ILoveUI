require "Vector"

local Controller = {}

function Controller:new()
    local c = {}

    c.Element = require "ILoveUI.Elements.Rectangle" :new()

    setmetatable(c, self)
    self.__index = self

    return c
end

return Controller