local EL = require("ILoveUI.Elements.LabelVariants.WriteableLabel")
local Label = EL:new()

function Label:new()
    local element = EL:new()
    
    element.onlySaveOnEnter = true

    setmetatable(element, self)
    self.__index = self

    return element
end

function Label:updateText()
    if self.tabel and self.varname then
        if tonumber(self.text) == nil then
            self.text = 0
        end
        self.tabel[self.varname] = tonumber(self.text)
    end
end

local allowed = "1234567890%-%."
function Label:textinput(t)
    if not self.writing then return end
    
    t = string.gsub(t, "[^"..allowed.."]", "")

    self.text = self.text .. t
    self:updateText()
end

return Label