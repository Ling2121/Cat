--[[
    场景由节点组成
    节点存储在链表中，根据深度进行顺序遍历
    节点中可以包含各种回调

    节点分为  普通节点和位置节点
    位置节点可以有子节点，子节点的位置原点为根节点
--]]
local depth_list = cat.require"base/list/depth_list"
local node = cat.require"module/game/scene/node/node"
local camera = cat.require"base/camera"

local scene = cat.object("scene",node){
    node = nil,
    camera = nil,
    _all_node = {},
}

--init callback
do
    for _,name in ipairs(cat.LOVE_CALLBACK) do
        if scene[name] == nil then
            scene[name] = function(self,...)
                for node in self._node:items() do
                    if node[name] then
                        node[name](node,...)
                    end
                end              
            end
        end
    end
end

function scene:__init__()
    node.__init__(self)
    self._node = depth_list()
    self.camera = camera()

    self:signal("enter_scene")
    self:signal("exit_scene")
    self:signal("object_leave_screen")
end

function scene:add_node(node)
    if node then
        local name = node.name or node
        if self._all_node[name] == nil then
            self._all_node[name] = node
            node.at_scene = self
            self._node:insert_node(node)
            node:emit_signal("enter_scene",self)
        end
    end
    return self
end

function scene:remove_node(node_or_name)
    if node_or_name == nil then return end

    local rmn = self._all_node[node_or_name]
    if type(node_or_name) == "table" then
        rmn = self._all_node[node_or_name.name]
    end
    if rmn then
        self._all_node[rmn.name] = nil
        self._node:remove_node(rmn)
        rmn:emit_signal("exit_scene",self)
    end
    return self
end

function scene:update(dt)
    for node in self._node:items() do
        if not node._stop_update then
            self._node:_update_node_depth(node)
            if node.update then
                node:update(dt)
            end
        end
    end
end

function scene:draw()
    for node in self._node:items() do
        if not node._stop_disply then
            if node.screen_draw then
                node:screen_draw(self.camera)
            end

            if node.draw then
                self.camera:draw_begin()
                    node:draw(self.camera)
                self.camera:draw_end()
            end
        end
    end    
end

return scene
