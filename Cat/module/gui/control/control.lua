local pnode = cat.require"module/game/scene/node/position_node"

local control = cat.class("control",pnode){
    _max_position = nil,
    _is_lock = false,
    _is_select = false,
    _is_hover = false,
    _is_clicking = false,
    _is_dragging = false,
    _open_drag = false,
    _drag_offset = {},
    _can_drag = true,
}

function control:__init__(x,y,w,h)
    pnode.__init__(self)
    self.position = cat.position(x or 0,y or 0)
    self._max_position = cat.position(w or love.graphics.getWidth(),h or love.graphics.getHeight()):set_root(self.position)

    self:signal("mouse_enter")
    self:signal("mouse_exit")
    self:signal("mouse_hit")
    self:signal("add_to_box")
    self:signal("remove_from_box")
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

function control:drag_mousepressed()
    local mx,my = cat.get_mouse_position()
    self._drag_offset.x = mx - self.position.x
    self._drag_offset.y = my - self.position.y
    if self._can_drag then
        self._is_dragging = true
        self._is_lock = true
    end
end

function control:drag_mousereleased()
    if self._is_dragging then
        self._is_lock = false
        self._is_dragging = false
    end
end

function control:drag_update()
    if self._is_dragging then
        local mx,my = cat.get_mouse_position()
        self.position.x = mx - self._drag_offset.x 
        self.position.y = my - self._drag_offset.y
    end
end

function control:draw()
    love.graphics.rectangle("fill",self.position.x,self.position.y,self._max_position.x- self.position.x,self._max_position.y - self.position.y)
end

return control