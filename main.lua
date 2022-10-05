local Base = require "controller"
local Rectangle = require "Elements.Rectangle"
local ElementList = require "Elements.ElementList"
local UIElement = require "UIElement"
local V0=UIElement:new();V0.pos=Vector:new(0,0);local V1=ElementList:new();V1.pos=Vector:new(10,0);V1.data.AutoAddIncrement=true;V1.data.Increment=10;local V2=Rectangle:new();V2.pos=Vector:new(0,0);V2.data.Size=Vector:new(100,20);V2.data.Color={1,1,1,1};V2:setParent(V1);V2=Rectangle:new();V2.pos=Vector:new(0,0);V2.data.Size=Vector:new(100,20);V2.data.Color={1,1,1,1};V2:setParent(V1);V2=Rectangle:new();V2.pos=Vector:new(0,0);V2.data.Size=Vector:new(100,50);V2.data.Color={1,1,1,1};V2:setParent(V1);V1:setParent(V0);

Base.base = V0
print(Base:toString())

--[[

list - just a list of elements, but it makes them display automatically, with increments and shit


]]--