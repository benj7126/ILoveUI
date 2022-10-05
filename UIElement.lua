local Element = {}

function Element:new()
    local element = {}

    element.pos = Vector:new(0, 0)
    element.parent = nil

    element.data = {} -- [name] = {data}

    element.children = {} -- [child] = isVisible (bool)

    --element.parameters = {} not a thing for now...

    setmetatable(element, self)
    self.__index = self

    return element
end

function Element:draw()
    self:drawThis()
    for i, v in pairs(self.children) do
        print(i)
        i:draw()
    end
end

function Element:drawThis()
    
end

function Element:setParent(parent)
    print(self.parent)
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

return Element