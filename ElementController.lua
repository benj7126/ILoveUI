local ElementController = {}

function ElementController:new(base)
    local controller = {}

    controller.keys = {}

    controller.base = base
    self.children = base.children

    setmetatable(controller, self)
    self.__index = self

    return controller
end

function ElementController:getWorldPos()
    return Vector:new(0, 0)
end

return ElementController