require "ILoveUI.Vector"
love.keyboard.setKeyRepeat(true)

local Controller = {}

function Controller:new()
    local c = {}

    c.fonts = {[""]={["12"]=love.graphics.newFont(12)}}
    c.images = {}

    c.writing = 0
    c.keys = {}

    setmetatable(c, self)
    self.__index = self

    c:link()

    return c
end

function Controller:getImage(path)
    if not self.images[path] then
        self.images[path] = love.graphics.newImage(path)
    end
    
    return self.images[path]
end

function Controller:getFont(path, size)
    if path == nil then
        return self.fonts[""]["12"]
    end
    if self.fonts[path][tostring(size)] then
        return self.fonts[path][tostring(size)]
    end

    local font = love.graphics.newFont(path, size)

    if font == nil then
        if not self.fonts[""][tostring(size)] then
            self.fonts[""][tostring(size)] = love.graphics.newFont(size)
        end

        self.fonts[path][tostring(size)] = self.fonts[""][tostring(size)]
    end
    
    return self.fonts[path][tostring(size)]
end

function Controller:setBaseElement(Element)
    self.Element = Element
    self.Element.C = self
end

function Controller:setKey(key, Element)
    self.keys[key] = Element
end

function Controller:link()

    love.run = function()
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
                    if self.Element then
                        self.Element:passCall(name, a,b,c,d,e,f)
                    end
                end
            end
    
            -- Update dt, as we'll be passing it to update
            if love.timer then dt = love.timer.step() end
    
            -- Call update and draw
            if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
    
            if self.Element then
                self.Element:passCall("update", dt)
            end
    
            if love.graphics and love.graphics.isActive() then
                love.graphics.origin()
                love.graphics.clear(love.graphics.getBackgroundColor())
                
                --if love.draw then love.draw() end -- might want to scrap love.draw

                if self.Element then
                    self.Element:passCall("draw")
                end
    
                love.graphics.present()
            end
    
            if love.timer then love.timer.sleep(0.001) end
        end
    end
end

return Controller