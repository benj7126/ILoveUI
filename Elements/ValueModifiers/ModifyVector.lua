local Element = require "UIElement"
local ValueModifierElement = Element:new();

-- not made at all
function ValueModifierElement:new()
    local element = Element:new()

    element.data["valueData"] = Vector:new(0, 0)
    element.data.passValue = function (val)
        print(val, "you need to set passValue")
    end

    local RRec = require "Elements.Rectangle" :new()
    RRec.data.Size = Vector:new(15, 15)
    RRec.data.Color = {1, 0, 0, 1}
    RRec:setParent(element)

    local GRec = require "Elements.Rectangle" :new()
    GRec.pos = Vector:new(0, 15)
    GRec.data.Size = Vector:new(15, 15)
    GRec.data.Color = {0, 1, 0, 1}
    GRec:setParent(element)

    local BackgroundRRec = require "Elements.Rectangle" :new()
    BackgroundRRec.pos = Vector:new(15, 0)
    BackgroundRRec.data.Color = {0.7, 0.7, 0.7, 1}
    BackgroundRRec.data.Size = Vector:new(85, 15)
    BackgroundRRec:setParent(RRec)
    local BackgroundGRec = require "Elements.Rectangle" :new()
    BackgroundGRec.pos = Vector:new(15, 0)
    BackgroundGRec.data.Color = {0.7, 0.7, 0.7, 1}
    BackgroundGRec.data.Size = Vector:new(85, 15)
    BackgroundGRec:setParent(GRec)

    local RTxt = require "Elements.Text": new()
    RTxt.data.Text = "X"
    RTxt.data.Align = "center"
    RTxt:setParent(RRec)
    local GTxt = require "Elements.Text": new()
    GTxt.data.Text = "Y"
    GTxt.data.Align = "center"
    GTxt:setParent(GRec)

    element.data.RNr = require "Elements.ValueModifiers.ModifyNumber" :new()
    element.data.RNr.data.Align = "center"
    element.data.RNr:setParent(BackgroundRRec)
    element.data.GNr = require "Elements.ValueModifiers.ModifyNumber" :new()
    element.data.GNr.data.Align = "center"
    element.data.GNr:setParent(BackgroundGRec)

    element.data.RNr.data.passValue = function (val)
        element.data.valueData.x = val or 0
        element.data.passValue(element.data.valueData)
    end
    element.data.GNr.data.passValue = function (val)
        element.data.valueData.y = val or 0
        element.data.passValue(element.data.valueData)
    end
    
    element.name = "ModifyVector"

    setmetatable(element, self)
    self.__index = self

    return element
end

function ValueModifierElement:setValue(val)
    self.data["valueData"] = val
    self.data.RNr.data.valueData = tostring(val.x)
    self.data.GNr.data.valueData = tostring(val.y)
end

function ValueModifierElement:keypressed(key)
    print(key, "a")
    if key == "tab" then
        if self.data.RNr.data.IsWriting then
            self.data.GNr.data.IsWriting = self.data.RNr.data.IsWriting
            self.data.RNr.data.IsWriting = not self.data.RNr.data.IsWriting
        elseif self.data.GNr.data.IsWriting then
            self.data.RNr.data.IsWriting = self.data.GNr.data.IsWriting
            self.data.GNr.data.IsWriting = not self.data.GNr.data.IsWriting
        end
    end
end

return ValueModifierElement