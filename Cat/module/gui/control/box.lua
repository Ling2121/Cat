local depth_list = cat.require"base/list/depth_list"
local control = cat.require"module/gui/control/control"

local box = cat.class("cat",control){
    control = nil,
    _control = nil,
    _all_control = {}
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
    control.__init__(self,x,y,w,h)
    self._control = depth_list()
end

function box:config_style(style)
    style = style or {}
    self.style.box_fill_mode = style.box_fill_mode or "line"
    self.style.box_color = style.box_color or cat.color(255,255,255,255)
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
                        self.control._is_dragging = false
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
        else
            self:drag_update()
        end
    else
        if self.control then
            self.control._is_select = false
            self.control._is_hover = false
            self.control._is_clicking = false
            self.control._is_dragging = false
            self.control:emit_signal("mouse_exit")
            self.control = nil
        end
    end
end

function box:mousepressed(x,y,button)
    if self.control then
        self.control:emit_signal("mouse_press",button)
        if self.control.mousepressed then
            self.control:mousepressed(x,y,button)
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
    else
        self:drag_mousereleased()
    end
end

function box:draw()
    love.graphics.setColor(self.style.box_color:unpack())
    love.graphics.rectangle(self.style.box_fill_mode,self.position.x,self.position.y,self._max_position.x- self.position.x,self._max_position.y - self.position.y)
    love.graphics.setColor(255,255,255,255)
    for ct in self._control:items() do
        if ct.draw then
            ct:draw()
        end
    end
end

return box