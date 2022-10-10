local Label = require "Elements.Label"
local ValueModifierElement = Label:new();

function ValueModifierElement:new()
    local element = Label:new()

    element.data["valueData"] = ""
    element.data.passValue = function (val)
        print(val, "you need to set passValue")
    end
    
    element.name = "ModifyNumber"

    setmetatable(element, self)
    self.__index = self

    return element
end

function ValueModifierElement:setValue(val)
    self.data["valueData"] = val
end

function ValueModifierElement:drawThis()
    self.data.Text = self.data.valueData
    Label.drawThis(self)
end

local allowed = "1234567890%."

function ValueModifierElement:eventChain(name, ...)
    self.data.Text = self.data.valueData
    if name == "textinput" then
        local txt, r = ...
        txt = string.gsub(txt, "[^"..allowed.."]", "")

        Label.eventChain(self, name, txt, r)
    else
        Label.eventChain(self, name, ...)
    end

    if self.data.valueData ~= self.data.Text then
        self.data.valueData = self.data.Text
        self.data.passValue(tonumber(self.data.valueData))
    end
end

return ValueModifierElement