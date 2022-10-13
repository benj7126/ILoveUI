local Font = {}

function Font:new(path, size)
    local f = {}

    if (type(path) == "number" and size == nil) then
        size = path
        path = nil
    end

    f.path = path or ""

    if path then
        f.font = love.graphics.newFont(path, size)
    else
        f.font = love.graphics.newFont(size)
    end

    setmetatable(f, self)
    self.__index = self

    return f
end

return Font