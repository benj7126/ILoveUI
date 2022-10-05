local utf8 = require("utf8")
local Text = require "Elements.Text"
local Label = Text:new()

function Label:new()
    local element = Text:new()

    element.data["IsWriting"] = false
    element.data["UseTopSize"] = true -- fx use size of box
    element.data["OnEnter"] = function () end

    element.data["StartWriting"] = function () end
    element.data["StopWriting"] = function () end

    element.data["WritingIndicator"] = "|"

    element.data["StopWritingOnEnter"] = true
    
    element.name = "Label"

    setmetatable(element, self)
    self.__index = self

    return element
end

function Label:mousepressed(x, y, b)
    if b ~= 1 then self.data.IsWriting = false; self.data.StopWriting(); return end

    if self.data.IsWriting then
        self.data.IsWriting = false
        self.data.StopWriting()
    else
        local pos = self:getWorldPos()
        local size = Vector:new(self.data.Limit, self.data.Font:getHeight())

        if self.data.UseTopSize then
            if self.parent.data.Size then
                size = self.parent.data.Size
            end
        end

        if x > pos.x and x < pos.x + size.x and y > pos.y and y < pos.y + size.y then
            self.data.IsWriting = true
            self.data.StartWriting()
        end
    end
end

function Label:drawThis()
    local pos = self:getWorldPos()

    local limit = self.data.Limit
    if limit == 0 and self.parent.data.Size then
        limit = self.parent.data.Size.x
    end

    local text = self.data.Text

    if self.data.IsWriting then
        text = text..self.data.WritingIndicator
    end

    love.graphics.setColor(0, 0, 0)

    love.graphics.printf(text, self.data.Font,
    pos.x, pos.y, limit, self.data.Align)

    love.graphics.setColor(1, 1, 1)
end

function Label:textinput(text)
    if self.data.IsWriting then
        self.data.Text = self.data.Text .. text
    end
end

function Label:keypressed(key)
    if self.data.IsWriting then
        if key == "backspace" then
            local byteoffset = utf8.offset(self.data.Text, -1)

            if byteoffset then
                self.data.Text = string.sub(self.data.Text, 1, byteoffset - 1)
            end
        elseif key == "return" then
            self.data.OnEnter()

            if self.data.StopWritingOnEnter then
                self.data.StopWriting()
                self.data.IsWriting = false
            end
        end
    end
end

return Label