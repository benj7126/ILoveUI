local base = require "controller"

local list = require("Elements.ElementList"):new()
list.data.Increment = 10 
list:setParent(base)

local but = require("Elements.Rectangle"):new()
but.data.Size = Vector:new(100, 20)
but:setParent(list)

local but = require("Elements.Rectangle"):new()
but.data.Size = Vector:new(100, 50)
but:setParent(list)

local but = require("Elements.Rectangle"):new()
but.data.Size = Vector:new(100, 20)
but:setParent(list)

--[[

list - just a list of elements, but it makes them display automatically, with increments and shit


]]--