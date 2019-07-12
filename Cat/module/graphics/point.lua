local baseg = cat.require"module/graphics/base_graphics"

local point = cat.class("point",baseg){}

function point:unpack()
    return self.position:unpack()
end

function point:draw()
    love.graphics.setColor(self.color:unpack())
    love.graphics.points(self.points:unpack())
    love.graphics.setColor(255,255,255,255)
end

return point