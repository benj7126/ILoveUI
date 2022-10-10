local Base=UIElement:new();

local SE = ScaleElement:new()
SE:setParent(Base)
SE.data.Size = Vector:new(800, 600)
SE.data.TargetSize = Vector:new(1920, 1080)
SE.data.Center = true

C:setKey("scalewindow", SE)

local UIWIndow = DrawableElement:new()
C:setKey("window", UIWIndow)

UIWIndow.pos = Vector:new(1920/4, 0)

UIWIndow.data.Size = Vector:new(1920/2, 1080)
UIWIndow.data.TargetSize = Vector:new(1920, 1080)
UIWIndow.data.Center = true
UIWIndow.drawPriority = -1

UIWIndow:setParent(SE)

local OtherUI=Empty:new();
C:setKey("UI", OtherUI)
--OtherUI.isActive = false

OtherUI:setParent(SE)

 -- element tree
local SideBar1 = Rectangle:new()
SideBar1.data.Color = {0.5, 0.5, 0.5, 1}
SideBar1.data.Size = Vector:new(1920/4, 1080)
SideBar1:setParent(OtherUI)

local ScrollE1 = Scroll:new()
ScrollE1.data.ScrollScale = 20
ScrollE1.data.Size = Vector:new(1920/4, 1080)
ScrollE1:setParent(SideBar1)
C:setKey("etwindow", ScrollE1)

 -- editing element
local ScrollE2 = Scroll:new()
ScrollE2.pos = Vector:new(1920/4*3, 0)
ScrollE2.data.Size = Vector:new(1920/4, 1080)
ScrollE2:setParent(OtherUI)

local SideBar2 = Rectangle:new()
SideBar2.data.Color = {0.5, 0.5, 0.5, 1}
SideBar2.data.Size = Vector:new(1920/4, 1080)
SideBar2:setParent(ScrollE2)
C:setKey("edwindow", SideBar2)


 -- txt message
 local uimessage = Rectangle:new()
 uimessage.data.Color = {1, 1, 1, 1}
 uimessage.drawPriority = 10
 uimessage.pos = Vector:new(1920-122, 1080-20)
 uimessage.data.Size = Vector:new(122, 20)
 uimessage:setParent(OtherUI)
 
 local uimessageT = Text:new()
 uimessageT.pos = Vector:new(2, 2)
 uimessageT.data.Text = "press u to toggle ui"
 uimessageT:setParent(uimessage)

 -- addElement
local MenuElement = Rectangle:new()
MenuElement.isActive = false
MenuElement.data.Color = {0.3, 0.3, 0.3, 1}
MenuElement.drawPriority = 11
--MenuElement.data.Size = Vector:new(122, 20)
MenuElement:setParent(OtherUI)
C:setKey("addEL", MenuElement)

--[[
local V1=ScaleElement:new();
V1.data.TargetSize=Vector:new(1920,1080);
V1.data.Size=Vector:new(800,600);
local V2=Rectangle:new();
V2.data.Size=Vector:new(1920,1080);
local V3=DrawableElement:new();
V3.drawPriority=10;
C:setKey("screen1",V3);
V3.data.TargetSize=Vector:new(1080,1080);
V3.data.KeepRatio=false;
V3.data.Size=Vector:new(1920,1080);
V3.data.Center=true;
V3:setParent(V2);
V2:setParent(V1);
V1:setParent(V0);
]]--


return Base;