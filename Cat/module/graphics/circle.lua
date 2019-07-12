local baseg = cat.require"module/graphics/base_graphics"

local circle = cat.class("point",baseg){
    radius = 10;
}

function circle:__init__(fill_mode,x,y,radius)
    baseg.__init__(self,fill_mode,x,y)
    self.radius = radius or 10
end

function circle:set_radius(r)
    self.radius = radius or self.radius
end

function circle:draw()
    love.graphics.setColor(self.color:unpack())
    love.graphics.circle(self.fill_mode,self.position.x,self.position.y,self.radius)
    love.graphics.setColor(255,255,255,255)
end

return circle