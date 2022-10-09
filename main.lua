require "vector"

MainController = require("ElementController"):new()
local Base=MainController.allElements.UIElement:new()
MainController.base = Base;

EditingController = require("ElementController"):new()
local editingBase=EditingController.allElements.UIElement:new()
EditingController.base = editingBase;

local Controller = require("editorController")("UI.lua")

local selectedElement = Base

Controller:setKeyValue("window", "DrawCall", function ()
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.rectangle("fill", 0, 0, 1920, 1080)
    MainController:draw()
end)

Controller:setKeyValue("edwindow", "DrawCall", function ()
    EditingController:draw()
end)

local allElementList = {}

local elementBase=Controller.allElements.TreeSegment:new()
elementBase.pos = Vector:new(0, 30)
elementBase.data.IncrementY = 5
elementBase.data.IncrementX = 5
elementBase:setParent(Controller.keys["elwindow"])

allElementList[Base] = {ListButton = elementBase}

function addElementAsChildFor(newElement, fatherElement)
    -- add element
    newElement:setParent(fatherElement)

    -- make its button
    local parrentElement = allElementList[fatherElement].ListButton

    local list = Controller.allElements.TreeSegment:new()
    list.data.IncrementY = 5
    list.data.IncrementX = 5
    print(list.parent, "f"); for i, v in pairs(parrentElement.children) do print(i, v, "k") end
    list:setParent(parrentElement)
    print(list.parent, "f"); for i, v in pairs(parrentElement.children) do print(i, v, "k") end

    local newButton = Controller.allElements.Button:new()
    newButton.data.Size = Vector:new(100, 30)
    list:setMainChild(newButton)

    newButton.data.OnClickHook = function ()
        selectedElement = newElement
    end
    
    allElementList[newElement] = {Button = newButton}

    return newElement
end

function love.mousepressed(x, y, b)
    if b == 2 then
        selectedElement = Base
    end
    
end

function love.keypressed(key)
    -- temp
    if key == "a" then
        local rec = Controller.allElements.Rectangle:new();
        rec.data.Size = Vector:new(10, 10)
        addElementAsChildFor(rec, selectedElement)
    end

    -- stuff
    if key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())

        local w, h = love.graphics.getWidth(), love.graphics.getHeight()
        Controller.keys["scalewindow"].data.Size = Vector:new(w, h)
    elseif key == "u" then
        Controller.keys["UI"].isActive = not Controller.keys["UI"].isActive

        if Controller.keys["UI"].isActive then
            Controller.keys["window"].pos = Vector:new(1920/4, 0)
            Controller.keys["window"].data.Size = Vector:new(1920/2, 1080)
        else
            Controller.keys["window"].pos = Vector:new(0, 0)
            Controller.keys["window"].data.Size = Vector:new(1920, 1080)
        end
    end
end