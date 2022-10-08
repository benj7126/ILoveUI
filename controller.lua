require "vector"
local Button = require "Elements.Button"
local DrawableElement = require "Elements.DrawableElement"
local ElementList = require "Elements.ElementList"
local Empty = require "Elements.Empty"
local Label = require "Elements.Label"
local Rectangle = require "Elements.Rectangle"
local ScaleElement = require "Elements.ScaleElement"
local Scroll = require "Elements.Scroll"
local Text = require "Elements.Text"

local UIElement = require "UIElement"

local Base = UIElement:new()
local SE = ScaleElement:new()
SE.data.Size = Vector:new(800, 600); SE.data.TargetSize = Vector:new(1920, 1080);
SE:setParent(Base)

local controller = require("ElementController"):new(Base)

local background = Rectangle:new()
background.data.Size = Vector:new(1920, 1080)
background:setParent(SE)

local gameScreen = DrawableElement:new()
gameScreen.pos = Vector:new(1920/4, 0)

gameScreen.data.Size = Vector:new(1920/4*3, 1080); gameScreen.data.TargetSize = Vector:new(1080, 1080);
controller:setKey("screen1", gameScreen)
gameScreen:setParent(background)


print(controller:toString())

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
                controller.base:eventChain(name, a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

        controller.base:eventChain("update", dt)

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())
			
			--if love.draw then love.draw() end -- might want to scrap love.draw
			
            controller.base:draw()

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

love.keyboard.setKeyRepeat(true)

return controller