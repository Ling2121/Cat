local box = cat.require("module/gui/control/box")
local control = cat.require"module/gui/control/control"
local slide = cat.require("module/gui/control/slide")

local win_title = cat.class("win_title",control){
    title = "Cat"
}

function win_title:__init__(t,x,y,w,h)
    control.__init__(self,x,y,w,h)
    self.title = t or "Cat"
end

function win_title:config_style(style)
    style = style or {}
    style.color = style.color or cat.color(60,50,150)
    style.font = style.font or cat.assets.font("default")
    style.font_color = style.font_color or cat.color(236,255,0)

    self.style = style
    return self
end

function win_title:draw()
    local x,y = self.position:unpack()
    local fh = self.style.font:getHeight()

    love.graphics.setColor(self.style.color:unpack())
    love.graphics.rectangle("fill",x,y,self._width,self._height)

    love.graphics.setFont(self.style.font)
    love.graphics.setColor(self.style.font_color:unpack())
    love.graphics.print(self.title,x + 4,y + self._height / 2 - fh / 2)
    love.graphics.setFont(cat.assets.font("default"))

    love.graphics.setColor(255,255,255,255)
end

local window = cat.class("window",box){
    _title   = nil,
    _content = nil,
    _slide_x = nil,
    _slide_y = nil,
    _content_max = {x = 0,y = 0}
}

function window:__init__(title,x,y,w,h)
    w = w or 400
    h = h or 320
    local tw,th = w,h * 0.08
    local ss = w * 0.04
    local syw,syh = ss,h - th - ss
    local sxw,sxh = w - syw,ss
    local cw,ch = w,h - th + 2

    local tx,ty = 0,0
    local cx,cy = 0,th
    local syx,syy = w - syw,th
    local sxx,sxy = 0,syy + syh

    self._content_max.x = w
    self._content_max.y = h
    self._title = win_title(title,tx,ty,tw,th)
    self._content = box(cx,cy,cw,ch)
    self._slide_x = slide("x",0,self._content_max.x,sxx,sxy,sxw,sxh)
    self._slide_y = slide("y",0,self._content_max.y,syx,syy,syw,syh)
    box.__init__(self,x,y,w,h)

    self
    :add_control(self._content:set_depth(-1))
    :add_control(self._slide_x)
    :add_control(self._slide_y)

    self._slide_x:connect("lock",self,"__lock__")
    self._slide_x:connect("unlock",self,"__unlock__")
    self._slide_y:connect("lock",self,"__lock__")
    self._slide_y:connect("unlock",self,"__unlock__")
end

function window:config_style(style)
    style = style or {}
    self._content:config_style({
         color = style.content_color or cat.color(60,30,130),
         box_fill_mode = "fill",
    })
    style.color = style.color or cat.color(236,255,0)
    style.box_fill_mode = "fill"
    self.style = style
    return self
end

function window:__lock__()
    self:lock()
end

function window:__unlock__()
    self:unlock()
end

return window

