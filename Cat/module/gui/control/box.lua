local pnode = cat.require"module/game/scene/node/position_node"
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

function box:add_control(control)
    if control then
        local name = control.name or control
        if self._all_control[name] == nil then
            self._all_control[name] = control
            control.at_box = self
            self._control:insert_node(control)
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
        if self.control == nil then
            for ct in self._control:items() do
                if ct:is_hover() then
                    ct._is_select = true
                    self.control = ct
                    ct:emit_signal("mouse_enter")
                    return
                end
            end
        else
            if not self.control._is_lock then
                if not self.control:is_hover() then
                    self.control._is_select = false
                    self.control:emit_signal("mouse_exit")
                    self.control = nil
                end
            end
        end

        if self.control then
            if self.control.update then
                self.control:update(dt)
            end
        end
    end
end

function box:draw()
    for ct in self._control:items() do
        if ct.draw then
            ct:draw()
        end
    end
end

return box