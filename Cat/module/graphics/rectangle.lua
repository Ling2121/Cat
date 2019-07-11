local baseg = cat.require"module/graphics/base_graphics"

local rectangle = cat.class("rectangle",baseg){
    width = 10,
    height = 10,
}

function rectangle:__init__(fill_mode,x,y,w,h)
    baseg.__init__(self,fill_mode,x,y)
    self.width = w or 10
    self.height = h or 10
end

function rectangle:draw()
    love.graphics.setColor(self.color:unpack())
    love.graphics.rectangle(self.fill_mode,self.position.x,self.position.y,self.width,self.height)
    love.graphics.setColor(255,255,255,255)
end


return rectangle