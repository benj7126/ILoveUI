local Element = {}

function Element:new()
    local element = {}

    element.pos = Vector:new(0, 0)
    element.parent = nil

    element.isVisible = true
    element.isActive = true

    element.drawPriority = 0

    element.key = ""
    
    element.name = "UIElement"

    element.data = {} -- [name] = {data}

    element.children = {} -- [child] = isVisible (bool)

    element.events = {}

    --element.parameters = {} not a thing for now...

    setmetatable(element, self)
    self.__index = self

    return element
end

local function checkPriority(list, value)
    for i , v in ipairs(list) do
        if v.drawPriority > value then
            return i
        end
    end
    return #list+1
end

function Element:getChildPriorityList()
    local priorityList = {}

    for i, v in pairs(self.children) do
        table.insert(priorityList, checkPriority(priorityList, i.drawPriority), i)
    end
    
    return priorityList
end


function Element:allowEvent(name)
    if not self.events[name] then
        self.events[name] = true
    end

    return self.events[name]
end

function Element:eventChain(name, ...)
    if not self.isActive then return end
    if not self:allowEvent(name) then return end
    
    if self[name] then
        self[name](self, ...)
    end

    for i, v in pairs(self.children) do
        i:eventChain(name, ...)
    end
end

function Element:draw()
    if not self.isActive then return end
    if not self.isVisible then return end

    self:drawThis()
    for i, v in pairs(self:getChildPriorityList()) do
        v:draw()
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

    if type(data) == "string" then
        return '"'..data..'"'
    end

    if tostring(data) or data.__tostring then
        return tostring(data)
    end

    return "error"
end

function Element:toCode(elements)
    local defaultElement = elements[self.name]:new()
    
    local str = "#="..self.name..":new();"

    if tostring(defaultElement.pos) ~= tostring(self.pos) then
        str = str .. "#.pos="..tostring(self.pos)..";"
    end
    if defaultElement.isVisible ~= self.isVisible then
        str = str .. "#.isVisible="..tostring(self.isVisible)..";"
    end
    if defaultElement.isActive ~= self.isActive then
        str = str .. "#.isActive="..tostring(self.isActive)..";"
    end
    if defaultElement.drawPriority ~= self.drawPriority then
        str = str .. "#.drawPriority="..tostring(self.drawPriority)..";"
    end

    if self.key ~= "" then
        str = str..'C:setKey("'..self.key..'",#);'
    end

    for i, v in pairs(self.data) do
        --print(transformData(v, i), transformData(defaultElement.data[i], i), "f", i)
        if type(v) ~= "function" then
            if transformData(v, i) ~= transformData(defaultElement.data[i], i) then
                --print("added")
                local data = transformData(v, i)
                str = str.."#.data."..i.."="..transformData(v, i)..";"
            end
        end -- functions cant be saved
    end

    return str
end

return Element