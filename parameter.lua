Parameter = {}

function Parameter:new(x, y)
    local vec = {}

    vec.x = x
    vec.y = y

    setmetatable(vec, self)
    self.__index = self

    return vec
end

return Vector