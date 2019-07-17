local box = cat.require("module/gui/control/box")
local control = cat.require"module/gui/control/control"

local slide_button = cat.class("slide_button",control){}

function slide_button:mousepressed()
    if self._can_drag then
        local mx,my = cat.get_mouse_position()
        self._drag_offset.x = mx - self.position._x
        self._drag_offset.y = my - self.position._y
        self:lock()
    end
end

function slide_button:mousereleased()
    if self._can_drag then
        if self._is_dragging then
            self:unlock()
            self._is_dragging = false
        end
    end
end

function slide_button:mousemoved()
    if self._can_drag then
        if self._is_clicking then
            local mx,my = cat.get_mouse_position()
            local mode = self.at_box.mode
            if mode == "x" then
                self.position.x = math.max(0,math.min(self.at_box._width - self._width,mx - self._drag_offset.x))
            elseif mode == "y" then
                self.position.y = math.max(0,math.min(self.at_box._height - self._height,my - self._drag_offset.y))
            end
        end
    end
end

local slide = cat.class("slide",box){
    mode = "x",
    is_draw_value = true,
    _min_value = 0,
    _max_value = 100,
    _add_value = 0,
    _drag_btn = nil,
    _drag_btn_size = 0,
}

function slide:__init__(mode,min,max,x,y,w,h)
    self.mode = mode or "x"
    self._min_value = min or 0

    box.__init__(self,x,y,w or 100,h or 20)
    self._drag_btn_size = self._width * 0.1
    self._drag_btn = slide_button(0,0,self._drag_btn_size,self._height)

    if self.mode == "y" then
        box.__init__(self,x,y,w or 20,h or 100)
        self._drag_btn_size = self._height * 0.1
        self._drag_btn = slide_button(0,0,self._width,self._drag_btn_size)
    end
    
    self._drag_btn._can_drag = true
    self:config_style(style)

    self:set_max_value(max or 100)
    self:add_control(self._drag_btn)
    self:connect("mouse_press",self,"__click__")
    self:connect("mouse_lift",self,"__lift__")
end

function slide:config_style(style)
    style = style or {}
    style.box_fill_mode = "fill"
    style.color = style.color or cat.color(60,50,150)
    style.bb_color = style.bb_color or cat.color(236,255,0)
    style.font = style.font or cat.assets.font("default")
    style.font_color = style.font_color or cat.color(0,0,0,255)

    if self._drag_btn then
        self._drag_btn.style.color = style.bb_color
    end
    self.style = style
    return self
end

function slide:set_max_value(v)
    self._max_value = v + math.max(0,-self._min_value)
    if self.mode == "x" then
        self._add_value = self._max_value / (self._width - self._drag_btn_size)
    elseif self.mode == "y" then
        self._add_value = self._max_value / (self._height - self._drag_btn_size)
    end
    return self
end

function slide:get_max_value()
    return self._max_value - math.max(0,-self._min_value)
end

function slide:get_value()
    if self.mode == "x" then
        local v = (self._min_value + self._drag_btn.position._x * self._add_value)
        return math.max(self._min_value,math.min(self._max_value,v))
    elseif self.mode == "y" then
        local v = self._min_value + self._drag_btn.position._y * self._add_value
        return math.max(self._min_value,math.min(self._max_value,v))
    end
end

function slide:__click__()
    self:lock()
end

function slide:__lift__()
    self:unlock()
end

function slide:draw()
    box.draw(self)
    if self.is_draw_value then
        local value = self:get_value()
        local fw,fh = self.style.font:getWidth(value),self.style.font:getHeight()
        local x,y = self.position:unpack()
        local r = 0
        y = y + self._height / 2 - fh / 2
        if self.mode == "y" then
            r = math.rad(90)
            x = (x + self._width) + self._width / 2 - fh / 2
            y = self.position.y
        end
        love.graphics.setFont(self.style.font)
        love.graphics.setColor(self.style.font_color:unpack())
        love.graphics.print(string.format("%.1f",value),x,y,r)
        love.graphics.setFont(cat.assets.font("default"))
    end
end

return slide

