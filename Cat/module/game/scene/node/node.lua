local depth_node = cat.require"base/list/depth_list".node_class

local node = cat.object("node",depth_node){
    name = nil,
    _at_scene = nil,--所在场景
    _stop_update = false,--暂停更新
    _stop_disply = false,--暂停绘制
}

function node:__init__()
    self:signal("enter_scene")
    self:signal("exit_scene")
    self.name = self
end

function node:set_name(name)
    self.name = name or self.name
    return self
end

function node:get_node(name)
    if self._at_scene then
        return self._at_scene:get_node(name)
    end
end

function node:get_position()
    return 0,0
end

return node




