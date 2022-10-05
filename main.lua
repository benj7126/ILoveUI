local Base = require "controller"
local Rectangle = require "Elements.Rectangle"
local ElementList = require "Elements.ElementList"
local Scroll = require "Elements.Scroll"
local UIElement = require "UIElement"
local V0=UIElement:new();V0.pos=Vector:new(0,0);local V1=ElementList:new();V1.pos=Vector:new(10,0);V1.data.AutoAddIncrement=true;V1.data.Increment=10;local V2=Rectangle:new();V2.pos=Vector:new(0,0);V2.data.Size=Vector:new(100,20);V2.data.Color={1,1,1,1};V2:setParent(V1);V2=Rectangle:new();V2.pos=Vector:new(0,0);V2.data.Size=Vector:new(100,20);V2.data.Color={1,1,1,1};V2:setParent(V1);V2=Rectangle:new();V2.pos=Vector:new(0,0);V2.data.Size=Vector:new(100,50);V2.data.Color={1,1,1,1};V2:setParent(V1);V1:setParent(V0);

V1.data.IncrementY = 8

local o = Scroll:new()
o.data.MaxScroll = 100
o.data.Stenscil = false
o.data.CheckBounds = false
V0:setParent(o)

Base.base = o


