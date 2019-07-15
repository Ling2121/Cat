local control = cat.require"module/gui/control/control"

local button = cat.class("button",control){
    label = "button",
    _hoffset = 0,
}

function button:__init__(label,x,y,w,h)
    control.__init__(self,x,y,w,h)
    self.label = label

    self:connect("mouse_enter",self,"__mouse_enter__")
    self:connect("mouse_exit",self,"__mouse_exit__")
end

function button:config_style(style)
    style = style or {}
    style.font = style.font or cat.assets.font("default")
    style.font_color = style.font_color or cat.color(236,255,0)
    style.color = style.color or cat.color(60,50,150)
    style.hoffset = style.hoffset or 3

    self.style = style
    return self
end

function button:__mouse_enter__()
    self._hoffset = self.style.hoffset
end

function button:__mouse_exit__()
    self._hoffset = 0
end

function button:mousepressed()
    self:drag_mousepressed()
end

function button:mousereleased()
    self:drag_mousereleased()
end

function button:update()
    self:drag_update()
end

function button:draw()
    local x,y = self.position:unpack()
    local fw,fh = self.style.font:getWidth(self.label),self.style.font:getHeight()
    local fx = x + self._width / 2 - fw / 2
    local fy = y + self._height / 2 - fh / 2
    local br,bg,bb,ba = self.style.color:unpack()
    local fr,fg,fb,fa = self.style.font_color:unpack()
    local frx,fry = x,y
    local subc = 1
    local hof = self._hoffset

    if self._is_clicking then
        hof = -self._hoffset
    end

    if self._is_select then
        love.graphics.setColor(fr * subc,fg* subc,fb* subc,fa* subc)
        love.graphics.rectangle("fill",x,y,self._width,self._height)
        love.graphics.setColor(br,bg,bb,ba)
        love.graphics.rectangle("line",x,y,self._width,self._height)
    end

    love.graphics.setColor(br,bg,bb,ba)
    love.graphics.rectangle("fill",x,y + hof,self._width,self._height)

    love.graphics.setFont(self.style.font)
    love.graphics.setColor(fr,fg,fb,fa)
    love.graphics.print(self.label,fx,fy + hof)
    love.graphics.setFont(cat.assets.font("default"))

    love.graphics.setColor(255,255,255,255)
end

return button