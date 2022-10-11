local Element = {}

function Element:new(o)
    local element = o or {}

    element.calls = {}

    element.children = {}

    element.pos = Vector:new()

    element.isActive = true

    setmetatable(element, self)
    self.__index = self

    return element
end

local ignoreList = {"new", "require", "__index", "passCall"}
local function doIgnore(callName)
    for i, v in pairs(ignoreList) do
        if v == callName then
            return true
        end
    end
    
    return false
end

function Element:require(elementName)
    local nElement = require(elementName)

    for i, v in pairs(nElement) do
        if doIgnore(i) == false then
            print(i, v)
        end
    end
end

function Element:passCall(name, ...)
    if not self.isActive then return end
    
    for i , v in pairs(self.calls) do
        if v[name] then
            v[name](self, ...)
        end
    end

    for i, v in pairs(self.children) do
        i:passCall(name, ...)
    end
end

return Element