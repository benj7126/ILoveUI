local Element = {}

function Element:new()
    local element = {}

    element.pos = Vector:new(0, 0)
    element.parent = nil

    element.key = ""
    
    element.name = "UIElement"

    element.data = {} -- [name] = {data}

    element.children = {} -- [child] = isVisible (bool)

    element.visible = true
    element.active = true

    element.events = {}

    --element.parameters = {} not a thing for now...

    setmetatable(element, self)
    self.__index = self

    return element
end

function Element:allowEvent(name)
    if not self.events[name] then
        self.events[name] = true
    end

    return self.events[name]
end

function Element:eventChain(name, ...)
    if not self.active then return end
    if not self:allowEvent(name) then return end
    
    if self[name] then
        self[name](self, ...)
    end

    for i, v in pairs(self.children) do
        i:eventChain(name, ...)
    end
end

function Element:draw()
    if not self.active then return end
    if not self.visible then return end

    self:drawThis()
    for i, v in pairs(self.children) do
        i:draw()
    end
end

function Element:drawThis()
    
end

function Element:setParent(parent)
    if self.parent then
        self.parent.children[self] = nil
    end
    
    self.parent = parent
    self.parent.children[self] = true
end

function Element:getWorldPos()
    local parentPos = Vector:new(0, 0)
    if self.parent then
        parentPos = self.parent:getWorldPos()
    end

    return parentPos+self.pos
end

local function getCode(depth, element)
    local str = (element:toCode()):gsub("#", "V"..depth)

    local firstItter = true

    for i, v in pairs(element.children) do
        local nstr = getCode(depth+1, i)
        if firstItter then
            nstr = "local "..nstr
            firstItter = false
        end
        
        nstr = nstr.."V"..(depth+1)..":setParent(V"..depth..");"

        str = str..nstr
    end



    return str
end

--[[
function Element:clone()
    local clone = loadstring("local "..getCode(0, self).."return V0;")()

    return clone
end
]]--

local function transformData(data, dataName)
    if dataName == "Color" then
        if #data == 4 then
            return "{"..data[1]..","..data[2]..","..data[3]..","..data[4].."}"
        else
            return "{"..data[1]..","..data[2]..","..data[3].."}"
        end
    end

    if tostring(data) or data.__tostring then
        return tostring(data)
    end

    return "error"
end

function Element:toCode()
    local str = "#="..self.name..":new();#.pos="..tostring(self.pos)..";"

    if self.key ~= "" then
        str = str.."Base:setKey("..self.key..",#);"
    end

    for i, v in pairs(self.data) do
        if type(v) ~= "function" then
            local data = transformData(v, i)
            str = str.."#.data."..i.."="..transformData(v, i)..";"
        end -- functions cant be saved
    end

    return str
end

return Element