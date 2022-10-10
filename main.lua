-- memo, make set default button

require "vector"

MainController = require("ElementController"):new()
local Base=MainController.allElements.UIElement:new()
MainController.base = Base;

EditingController = require("ElementController"):new()
local editingBase=EditingController.allElements.UIElement:new()
EditingController.base = editingBase;

local IsWriitng = false
local startWriting = function ()
    IsWriitng = true
end
local stopWriting = function ()
    IsWriitng = false
end

local Controller = require("editorController")("UI.lua")

local addedElements = 0

local allElementList = {}

local selectedElement = Base
local markRec = Controller.allElements.Rectangle:new()
markRec.data.Color = {1, 1, 0, 0.4}

function selectElement(element)
    updateElementEditor(element)
    if not element then markRec:remParent(); return end

    local listElement = allElementList[element].ListButton
    local button = listElement.data.mainChild

    if button then
        markRec:setParent(button)
        markRec.data.Size = button.data.Size

        selectedElement = element
    end
end

function updateElementEditor(element)
    IsWriitng = false

    local parent = Controller.keys["edwindow"]
    parent.children = {} -- clear the children

    if not element then return end

    local listE = Controller.allElements.ListElement:new()
    listE.pos = Vector:new(5, 5)
    listE.data.IncrementY = 5
    listE:setParent(parent)
    
    local editor = {"pos", "key", "drawPriority", "isVisible", "isActive"}
    for i, v in pairs(element.data) do
        table.insert(editor, i)
    end
    for i, v in ipairs(editor) do
        --element[v]
        local baseRect = Controller.allElements.Rectangle:new()
        baseRect.data.Size = Vector:new(100, 30)
        baseRect:setParent(listE)

        local ValLabel = Controller.allElements.Text:new()
        ValLabel.pos = Vector:new(0, 6)
        ValLabel.data.Align = "center"
        ValLabel.data.Text = v

        ValLabel:setParent(baseRect)

        local valRect = Controller.allElements.Rectangle:new()
        valRect.data.Size = Vector:new(100, 30)
        valRect.pos = Vector:new(120, 0)
        valRect:setParent(baseRect)

        local r;
        if element[v] then
            r = setupEditorElement(element, element[v], v)
        else
            r = setupEditorElement(element.data, element.data[v], v)
        end
        if r then
            r:setParent(valRect)
        end
    end
end

function setupEditorElement(baseElement, value, valueName)
    local ValMod;
    
    if type(value) == "string" or type(value) == "number" then
        if type(value) == "string" then
            ValMod = Controller.allElements.ModifyString:new()
        else
            ValMod = Controller.allElements.ModifyNumber:new()
        end

        ValMod.pos = Vector:new(0, 6)

        ValMod.data.StartWriting = startWriting
        ValMod.data.StopWriting = stopWriting

        ValMod.data.Align = "center"
    elseif type(value) == "table" and value.isVec then
        ValMod = Controller.allElements.ModifyVector:new()

        ValMod.data.RNr.data.StartWriting = startWriting
        ValMod.data.GNr.data.StopWriting = stopWriting
    else
        return
    end
    
    ValMod:setValue(baseElement[valueName])

    ValMod.data.passValue = function (val)
        baseElement[valueName] = val
    end

    return ValMod
end

Controller:setKeyValue("window", "DrawCall", function ()
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.rectangle("fill", 0, 0, 1920, 1080)
    MainController:draw()
end)

local elementBase=Controller.allElements.TreeSegment:new()
elementBase.pos = Vector:new(5, 5)
elementBase.data.IncrementY = 5
elementBase.data.IncrementX = 5
elementBase:setParent(Controller.keys["etwindow"])

Controller.keys["etwindow"].update = function (self, dt)
    self:setMinMax(-elementBase.data.Size.y, 0)
end

local addEL = Controller.keys["addEL"]

local listEL = Controller.allElements.ListElement:new()
listEL.pos = Vector:new(5, 5)
listEL.data.IncrementY = 5
listEL:setParent(addEL)

addEL.mousepressed = function (self, x, y, b)
    if b == "add" then
        print("a")
        self.pos = Vector:new(x, y)
        self.data.Size = Vector:new(120, listEL:calcHeight()+20)
    end
end

for i, v in pairs(Controller.allElements) do
    local b = Controller.allElements.Button:new()
    b.pos = Vector:new(5, 5)
    b.data.Size = Vector:new(100, 20)

    b.data.OnClickHook = function ()
        addElementAsChildFor(v:new(), selectedElement)
        addEL.isActive = false
    end

    b:setParent(listEL)
    
    local t = Controller.allElements.Text:new()
    t.data.Text = i
    t:setParent(b)
end



allElementList[Base] = {ListButton = elementBase}

function addElementAsChildFor(newElement, fatherElement)
    -- add element
    newElement:setParent(fatherElement)

    -- make its button
    local parrentElement = allElementList[fatherElement].ListButton

    local list = Controller.allElements.TreeSegment:new()
    list.data.IncrementY = 5
    list.data.IncrementX = 5

    list.drawPriority = addedElements
    addedElements = addedElements + 1
    
    list:setParent(parrentElement)

    local newButton = Controller.allElements.Button:new()
    newButton.data.Size = Vector:new(100, 30)
    list:setMainChild(newButton)

    newButton.data.OnClickHook = function (b)
        if b == 1 then
            selectElement(newElement)
        elseif b == 2 then
            list.data.isOpen = not list.data.isOpen
        end
    end
    
    allElementList[newElement] = {ListButton = list}

    return newElement
end

function love.mousepressed(x, y, b)
    if b == 2 then
        selectedElement = Base
        selectElement(nil)
    end
    
end

function love.keypressed(key)
    -- temp

    if IsWriitng then return end

    if key == "a" then
        local addEL = Controller.keys["addEL"]

        if not addEL.isActive then
            addEL.isActive = true
            local x, y = love.mouse.getPosition()
            Controller:eventChain("mousepressed", x, y, "add")
        else
            addEL.isActive = false
        end
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