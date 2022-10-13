local utf8 = require("utf8")

local EL = require("ILoveUI.Elements.Label")
local Label = EL:new()

function Label:new()
    local element = EL:new()
    
    element.writing = false

    element.onlySaveOnEnter = false
    element.textBeforeWriting = ""
    
    element.table = nil
    element.varname = nil

    setmetatable(element, self)
    self.__index = self

    return element
end

function Label:mousepressed(x, y, b)
    if b == 1 then
        local pos = self:getWorldPosition()
        local w, h = self.limit, self.font.font:getHeight()
        
        if x > pos.x and x < pos.x+w and y > pos.y and y < pos.y+h then
            local C = self:getC();
            self.writing = true

            self.textBeforeWriting = self.text
            
            C.writing = C.writing + 1
        else
            if self.writing then
                local C = self:getC();
                self.writing = false

                if self.onlySaveOnEnter then
                    self.text = self.textBeforeWriting
                end

                C.writing = C.writing - 1
            end
        end
    end
end

function Label:LinkTableVar(table, varname)
    self.tabel = table
    self.varname = varname
    self:updateText()
end

function Label:updateText()
    if self.tabel and self.varname then
        self.tabel[self.varname] = self.text
    end
end

function Label:textinput(t)
    if not self.writing then return end
    self.text = self.text .. t

    if not self.onlySaveOnEnter then
        self:updateText()
    end
end

function Label:keypressed(key)
    if not self.writing then return end

    if key == "backspace" then
        local byteoffset = utf8.offset(self.text, -1)

        if byteoffset then
            self.text = string.sub(self.text, 1, byteoffset - 1)
            if not self.onlySaveOnEnter then
                self:updateText()
            end
        end
    elseif key == "return" then
        local C = self:getC();
        self.writing = false

        C.writing = C.writing - 1

        self:updateText()
    end
end

return Label