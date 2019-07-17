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
    _title = "cat",
    _title_width = nil,
    _title_height = nil,
    _origin = nil,
    _content = nil,
    _slide_x = nil,
    _slide_y = nil,
    _content_width = 0,
    _content_height = 0,
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

    self._content_width = cw
    self._content_height = ch
    self._title = title
    self._title_width = tw
    self._title_height = th
    self._origin = control(tx,ty + th)
    self._content = box(cx,cy,cw,ch)
    self._slide_x = slide("x",0,0,sxx,sxy,sxw,sxh)
    self._slide_y = slide("y",0,0,syx,syy,syw,syh)
    box.__init__(self,x,y,w,h)

    self._origin.draw = nil
    box.add_control(self,self._origin)
    box.add_control(self,self._content:set_depth(-1))
    box.add_control(self,self._slide_x)
    box.add_control(self,self._slide_y)

    self._slide_x:connect("lock",self,"__lock__")
    self._slide_x:connect("unlock",self,"__unlock__")
    self._slide_y:connect("lock",self,"__lock__")
    self._slide_y:connect("unlock",self,"__unlock__")
end

function window:config_style(style)
    style = style or {}
    style.font = style.font or cat.assets.font("default")
    style.font_color = style.font_color or cat.color(236,255,0)
    style.color = style.color or cat.color(60,50,150)

    local r,g,b,a = style.color:unpack()

    self._slide_x:config_style({
        color = cat.color(r - 10,g - 10,b - 10)
    })
    self._slide_y:config_style({
        color = cat.color(r - 10,g - 10,b - 10)
    })

    self._content:config_style({
         color = cat.color(r - 25,g - 15,b - 25),
         box_fill_mode = "fill",
    })

    style.box_fill_mode = "fill"
    self.style = style
    return self
end

function window:__lock__()
    self._is_lock = true
end

function window:__unlock__()
    self._is_lock = false
end

function window:add_control(control)
    if control then
        local name = control.name or control
        if self._all_control[name] == nil then
            self._all_control[name] = control
            control.at_box = self
            self._control:insert_node(control)
            control:set_root(self._origin)




            local w = (control.position._x + control._width) - self._content_width
            local h = (control.position._y + control._height) - self._content_height

            print(w,h)
            self._slide_x:set_max_value(math.max(0,w))
            self._slide_y:set_max_value(math.max(0,h))
            control:emit_signal("add_to_box",self)
        end
    end

    return self
end

function window:update(dt)
    box.update(self,dt)
    local x_value = self._slide_x:get_value()
    local y_value = self._slide_y:get_value()
    self._origin.position.x = -x_value
    self._origin.position.y = -y_value
end

function window:draw()
    box.draw(self)
    local x,y = self.position:unpack()
    local fh = self.style.font:getHeight()

    love.graphics.setColor(self.style.color:unpack())
    love.graphics.rectangle("fill",x,y,self._title_width,self._title_height)

    love.graphics.setFont(self.style.font)
    love.graphics.setColor(self.style.font_color:unpack())
    love.graphics.print(self._title,x + 4,y + self._title_height / 2 - fh / 2)
    love.graphics.setFont(cat.assets.font("default"))

    love.graphics.setColor(255,255,255,255)
end

return window

