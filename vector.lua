Vector = {}

function Vector:new(x, y)
    local vec = {}

    vec.x = x or 0
    vec.y = y or 0

    setmetatable(vec, self)
    self.__index = self

    return vec
end

function Vector:__add(vector)
    return Vector:new(self.x+vector.x, self.y+vector.y)
end

function Vector:__sub(vector)
    return Vector:new(self.x-vector.x, self.y-vector.y)
end

function Vector:__mul(nr)
    return Vector:new(self.x*nr, self.y*nr)
end

function Vector:__div(nr)
    return Vector:new(self.x/nr, self.y/nr)
end

function Vector:__eq(vector)
    return self.x==vector.x and self.y==vector.y
end

function Vector:__tostring()
    return "Vector:new("..self.x..","..self.y..")"
end

return Vector