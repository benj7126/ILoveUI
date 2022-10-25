local Element = {}

function Element:new()
    local element = {}

    element.variablesLinkedToParent = {}
    element.variablesLinkedFromParent = {}

    element.subelements = {} -- elements that make up this element
    element.children = {} -- elements that are under this 
    
    element.parent = nil

    element.drawPriority = 0

    element.C = nil -- the ui Controller, for storing global things i guess

    element.pos = Vector:new()
    element.isActive = true

    setmetatable(element, self)
    self.__index = self

    return element
end

local function sortListOfElements(elements)
    local elementsToReturn = {}

    for _, v in pairs(elements) do
        local didAdd = false
        
        for i, v2 in pairs(elementsToReturn) do
            if v.drawPriority > v2.drawPriority then
                table.insert(elementsToReturn, i, v)
                didAdd = true
                break
            end
        end

        if didAdd == false then
            table.insert(elementsToReturn, v)
        end
    end

    return elementsToReturn
end

function Element:getSortedChildList()
    return sortListOfElements(self.children)
end

function Element:getSortedSubElementList()
    return sortListOfElements(self.subelements)
end

function Element:updateVariables()
    local p = self.parent
    if p then
        for i, v in pairs(self.variablesLinkedToParent) do
            self[i] = v[1](p[i])
        end
        for i, v in pairs(self.variablesLinkedFromParent) do
            self[i] = v(p[i])
        end
    end
end

function Element:updateParentVariables()
    local p = self.parent
    if p then
        for i, v in pairs(self.variablesLinkedToParent) do
            p[i] = v[2](self[i])
        end
    end
end

function Element:linkVarToParent(varname, repFuncIn, repFuncOut)
    if repFuncIn == nil then repFuncIn = function(value) return value end end
    if repFuncOut == nil then repFuncOut = function(value) return value end end

    self.variablesLinkedToParent[varname] = {repFuncIn, repFuncOut}
end

function Element:linkVarFromParent(varname, repFunc)
    if repFunc == nil then repFunc = function(value) return value end end

    self.variablesLinkedFromParent[varname] = repFunc
end

function Element:getC()
    if self.C then
        return self.C
    else
        return self.parent:getC()
    end
end

function Element:getWorldPosition()
    local pos = Vector:new()

    if self.parent then
        pos = self.parent:getWorldPosition()
        if self.parent.getAditionalOffset then
            pos = pos + self.parent:getAditionalOffset(self)
        end
    end

    pos = pos + self.pos

    return pos
end

function Element:getMousePosition()
    local pos;
    if self.parent then
        pos = self.parent:getMousePosition()
    else
        local x, y = love.mouse.getPosition()
        pos = Vector:new(x, y)
    end
    return pos
end

function Element:addSubElement(elementName)
    local EL = require(elementName):new()

    table.insert(self.subelements, EL)
    EL.parent = self

    return EL
end

function Element:clearParent()
    if self.parent then
        for i, v in ipairs(self.parent.children) do
            if v == self then
                table.remove(self.parent.children, i)
                self.parent = nil
                return
            end
        end
    end
end

function Element:addChild(element)
    element:clearParent()
    table.insert(self.children, element)
    element.parent = self
end

function Element:setParent(element)
    self:clearParent()
    table.insert(element.children, self)
    self.parent = element
end

function Element:tryCalls(name, ...)
    if self[name] then
        self[name](self, ...)
    end
    
    for i, v in ipairs(self:getSortedSubElementList()) do
        v:passCall(name, ...)
    end

    for i, v in ipairs(self:getSortedChildList()) do
        v:passCall(name, ...)
    end
end

function Element:passCall(name, ...)
    self:updateVariables()
    if not self.isActive then return end

    local doIgnore = false
    if self["ignore_"..name] then
        doIgnore = self["ignore_"..name](self, ...)
    end

    if doIgnore == false then
        if self["pre_"..name] then
            self:tryCalls(name, self["pre_"..name](self, ...))
        else
            self:tryCalls(name, ...)
        end
        if self["post_"..name] then
            self["post_"..name](self, ...)
        end
    end

    self:updateParentVariables()
end

return Element