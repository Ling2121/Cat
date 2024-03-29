local depth_list = cat.require"base/list/depth_list"
local control = cat.require"module/gui/control/control"

local box = cat.class("cat",control){
    control = nil,
    _control = nil,
    _all_control = {},
    _lock_change = false,
}

do
    for _,name in ipairs(cat.LOVE_CALLBACK) do
        if box[name] == nil then
            box[name] = function(self,...)
                if self.control then
                    if self.control[name] then
                        self.control[name](self.control,...)
                    end
                end     
            end
        end
    end
end

function box:__init__(x,y,w,h)
    control.__init__(self,x,y,w or love.graphics.getWidth(),h or love.graphics.getHeight())
    self._control = depth_list()
end

function box:config_style(style)
    style = style or {}
    style.box_fill_mode = style.box_fill_mode or "line"
    style.color = style.color or cat.color(255,255,255,255)

    self.style = style
    return self
end

function box:add_control(control)
    if control then
        local name = control.name or control
        if self._all_control[name] == nil then
            self._all_control[name] = control
            control.at_box = self
            self._control:insert_node(control)
            control:set_root(self)
            control:emit_signal("add_to_box",self)
        end
    end

    return self
end

function box:remove_control(control_or_name)
    if control_or_name == nil then return end

    local rmc = self._all_control[control_or_name]
    if type(control_or_name) == "table" then
        rmc = self._all_control[control_or_name.name]
    end
    if rmc then
        self._all_control[rmc.name] = nil
        self._control:remove_node(rmc)
        rmc:emit_signal("remove_from_box",self)
    end

    return self
end

function box:update(dt)
    if self._is_select then
        for ct in self._control:eitems() do
            self._control:_update_node_depth(ct)
        end
        repeat
            if self.control and self.control._is_lock then
                break
            end

            for ct in self._control:eitems() do
                if ct:is_hover() then
                    ct._is_select = true
                    ct._is_hover = true
                    if self.control and ct ~= self.control then
                        self.control._is_select = false
                        self.control._is_hover = false
                        self.control._is_clicking = false
                        self.control:emit_signal("mouse_exit")
                    end
                    self.control = ct
                    ct:emit_signal("mouse_enter")
                    break
                end
            end
        until(true)

        if self.control then
            if not self.control._is_lock then
                if not self.control:is_hover() then
                    self.control._is_select = false
                    self.control._is_hover = false
                    self.control:emit_signal("mouse_exit")
                    self.control = nil
                end
            end
        end

        if self.control then
            self.control._is_clicking = love.mouse.isDown(1)
            if self.control.update then
                self.control:update(dt)
            end
        end
    else
        if self.control then
            self.control._is_select = false
            self.control._is_hover = false
            self.control._is_clicking = false
            self.control:emit_signal("mouse_exit")
            self.control = nil
        end
    end
end

function box:mousemoved(x,y,dx,dy)
    if self.control then
        if self.control.mousemoved then
            self.control:mousemoved(x,y,dx,dy)
        end
    else
        self:drag_mousemoved()
    end
end

function box:mousepressed(x,y,button)
    if self.control then
        self.control:emit_signal("mouse_press",button)
        if self.control.mousepressed then
            self.control:mousepressed(x,y,button)
        end

        if not self.control._is_lock then
            self._lock_change = true
            self.control:lock()
        end
    else
        self:drag_mousepressed()
    end
end

function box:mousereleased(x,y,button)
    if self.control then
        self.control:emit_signal("mouse_lift",button)
        if self.control.mousereleased then
            self.control:mousereleased(x,y,button)
        end

        if self._lock_change then
            self._lock_change = false
            self.control:unlock()
        end
    else
        self:drag_mousereleased()
    end
end

function box:draw()
    local sx, sy, sw, sh = love.graphics.getScissor()
    love.graphics.intersectScissor(self.position.x,self.position.y,self._width,self._height)
    love.graphics.setColor(self.style.color:unpack())
    love.graphics.rectangle(self.style.box_fill_mode,self.position.x,self.position.y,self._width,self._height)
    love.graphics.setColor(255,255,255,255)

    for ct in self._control:items() do
        if ct.draw then
            ct:draw()
        end
    end

    love.graphics.setScissor(sx, sy, sw, sh)
end

return box