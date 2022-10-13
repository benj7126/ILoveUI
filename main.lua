local C = require "ILoveUI.UIController" :new()
local Button = require("ILoveUI.Elements.ButtonVariants.ButtonWithBackground"):new()
C:setBaseElement(Button)

Button.size = Vector:new(100, 100)

Button.onClick[1] = function () print("click") end
Button.onPress[1] = function () print("press") end
Button.onRelease[1] = function () print("release") end