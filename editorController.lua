require "vector"

local C = require("ElementController"):new()

local function setup(str)
	if love.filesystem.getInfo(str) then
		local contents, size = love.filesystem.read(str)
		str = contents
	end

	-- for i, v in pairs(C.allElements) do
	-- 	str = string.gsub(str, "("..i..")", '["%1"]')
	-- end

	-- print(str)
	
	C:loadFromString(str)
	
	return C
end

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
                C:eventChain(name, a,b,c,d,e,f)
				MainController:eventChain(name, a,b,c,d,e,f)
				EditingController:eventChain(name, a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

        C:eventChain("update", dt)

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())
			
			--if love.draw then love.draw() end -- might want to scrap love.draw
			
            C:draw()

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

love.keyboard.setKeyRepeat(true)

return setup