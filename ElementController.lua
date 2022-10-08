local ElementController = {}

function ElementController:new()
    local controller = {}

    controller.keys = {}

    controller.base = nil
    controller.children = nil

    controller.allElements = {["UIElement"] = require("UIElement"), ["Vector"] = Vector, ["C"]=controller}

    local elements = love.filesystem.getDirectoryItems("Elements")

    for i, v in pairs(elements) do
        local name = v:sub(1, #v-4)
        controller.allElements[name] = require ("Elements/"..name)
    end


    setmetatable(controller, self)
    self.__index = self

    return controller
end

function ElementController:eventChain(...)
    if self.base then
        self.base:eventChain(...)
    end
end

function ElementController:draw(...)
    if self.base then
        self.base:draw(...)
    end
end

function ElementController:loadFromString(str)
    local chunk = load(str, nil, "t", self.allElements)
    self.base = chunk()

    self.children = self.base

    --print(self:toString())
end

function ElementController:setKey(key, element)
    element.key = key
    self.keys[key] = element
end

function ElementController:setKeyValue(key, valueName, nValue)
    if self.keys[key] then
        if self.keys[key].data[valueName] then
            self.keys[key].data[valueName] = nValue
            return true
        end
    end

    return false
end

function ElementController:getWorldPos()
    return Vector:new(0, 0)
end

local function getCode(depth, element, elements)
    local str = (element:toCode(elements)):gsub("#", "V"..depth)

    local firstItter = true

    for i, v in pairs(element.children) do
        local nstr = getCode(depth+1, i, elements)
        if firstItter then
            nstr = "local "..nstr
            firstItter = false
        end
        
        nstr = nstr.."V"..(depth+1)..":setParent(V"..depth..");"

        str = str..nstr
    end



    return str
end

function ElementController:toString()
    return "local "..getCode(0, self.base, self.allElements).."return V0;"
end

function ElementController:fromString()
    
end

return ElementController