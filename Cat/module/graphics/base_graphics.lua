local pnode = cat.require"module/game/scene/node/position_node"

local base_graphics = cat.class("base_graphics",pnode){
    fill_mode = "line",
    color = nil,
}

function base_graphics:__init__(fill_mode,x,y)
    pnode.__init__(self,x,y)
    self.fill_mode = fill_mode or "line"
    self.color = cat.color(255,255,255,255)
end

function base_graphics:set_color(r,g,b,a)
    self.color.r = r or  self.color.r
    self.color.g = r or  self.color.g
    self.color.b = r or  self.color.b
    self.color.a = r or  self.color.a

    return self
end

return base_graphics