local pnode = cat.require"module/game/scene/node/position_node"

local control = cat.class("control",pnode){
    style = {},
    _width = 0,
    _height = 0,
    _max_position = nil,
    _is_lock = false,
    _is_select = false,
    _is_hover = false,
    _is_clicking = false,
    _is_dragging = false,
    _drag_offset = {x = 0,y = 0},
    _can_drag = false,
}

function control:__init__(x,y,w,h)
    pnode.__init__(self)
    self.position = cat.position(x or 0,y or 0)
    self._max_position = cat.position(w,h):set_root(self.position)
    self._width = w
    self._height = h
    self:config_style()
    self:signal("mouse_enter")
    self:signal("mouse_exit")
    self:signal("mouse_press")
    self:signal("mouse_lift")
    self:signal("add_to_box")
    self:signal("lock")
    self:signal("unlock")
    self:signal("remove_from_box")
end

function control:config_style(style)
    style = style or {}
    style.color = style.color or cat.color(60,50,150)
    self.style = style
    return self
end

function control:set_box(w,h)
    self._width = w or self._width
    self._height = h or self._height
    self._max_position.x = self._width
    self._max_position.y = self._height
end

function control:is_hover()
    local mx,my = cat.get_mouse_position()
    local min,max =  self.position, self._max_position
    return (mx >= min.x and my >= min.y and mx <= max.x and my <= max.y)
end

function control:is_hit(button,...)
    button = button or 1
    return (love.mouse.isDown(button,...) and self:is_hover())
end

function control:lock()
    self:emit_signal("lock")
    self._is_lock = true
end

function control:unlock()
    self:emit_signal("unlock")
    self._is_lock = false
end

function control:drag_mousepressed()
    if self._can_drag  then
        local mx,my = cat.get_mouse_position()
        self._drag_offset.x = mx - self.position._x--_x未经变换的位置
        self._drag_offset.y = my - self.position._y
        self:lock()
    end
end

function control:drag_mousereleased()
    if self._can_drag then
        if self._is_dragging then
            self._is_dragging = false
        end
        self:unlock()
    end
end

function control:drag_mousemoved()
    if self._can_drag then
        if self._is_clicking then
            local mx,my = cat.get_mouse_position()
            self.position.x = mx - self._drag_offset.x
            self.position.y = my - self._drag_offset.y
        end
    end
end

function control:draw()
    love.graphics.setColor(self.style.color:unpack())
    love.graphics.rectangle("fill",self.position.x,self.position.y,self._width,self._height)
    love.graphics.setColor(255,255,255,255)
end

return control