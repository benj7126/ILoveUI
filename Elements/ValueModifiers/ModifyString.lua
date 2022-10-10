local Label = require "Elements.Label"
local ValueModifierElement = Label:new();

function ValueModifierElement:new()
    local element = Label:new()

    element.data["valueData"] = ""
    element.data.passValue = function (val)
        print(val, "you need to set passValue")
    end
    
    element.name = "ModifyString"

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

function ValueModifierElement:eventChain(name, ...)
    self.data.Text = self.data.valueData
    Label.eventChain(self, name, ...)

    if self.data.valueData ~= self.data.Text then
        self.data.valueData = self.data.Text
        self.data.passValue(self.data.valueData)
    end
end

return ValueModifierElement