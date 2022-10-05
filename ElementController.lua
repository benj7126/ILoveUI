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

function ElementController:setKey(key, element)
    element.key = key
    self.keys[key] = element
end
function ElementController:getWorldPos()
    return Vector:new(0, 0)
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

function ElementController:toString()
    return "local "..getCode(0, self.base)
end

function ElementController:fromString()
    
end

return ElementController