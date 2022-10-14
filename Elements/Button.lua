local EL = require("ILoveUI.Elements.Label")
local Label = EL:new()

function Label:new()
    local element = EL:new()
    
    element.size = Vector:new()

    element.onPress = {nil, nil, nil}
    element.onClick = {nil, nil, nil}
    element.onRelease = {nil, nil, nil}

    element.lastPress = {false, false, false}
    -- if it hit the with mouse button 1, 2 or 3

    setmetatable(element, self)
    self.__index = self

    return element
end

function Label:mousepressed(x, y, b)
    local pos = self:getWorldPosition()
    local w, h = self.size.x, self.size.y

    if x > pos.x and x < pos.x+w and y > pos.y and y < pos.y+h then
        self.lastPress[b] = true

        if self.onPress[b] then
            self.onPress[b]()
        end
    else
        self.lastPress[b] = false
    end
end

function Label:mousereleased(x, y, b)
    local pos = self:getWorldPosition()
    local w, h = self.size.x, self.size.y

    if x > pos.x and x < pos.x+w and y > pos.y and y < pos.y+h then
        if self.lastPress[b] then
            if self.onClick[b] then
                self.onClick[b]()
            end
        end
        if self.onRelease[b] then
            self.onRelease[b]()
        end
    else
        self.lastPress[b] = false
    end
end

return Label