local pnode = cat.require"module/game/scene/node/position_node"

local image = cat.class("image",pnode){
    assets_name = nil,
}

function image:__init__(path,x,y,r,sx,sy)
    pnode.__init__(self,x,y)
    self.assets_name = path
    self.r = r or 0
    self.sx = sx or 1
    self.sy = sy or 1
end

function image:draw()
    cat.graphics.draw(self.assets_name,self.position.x,self.position.y,self.r,self.sx,self.sy)
end

return image

