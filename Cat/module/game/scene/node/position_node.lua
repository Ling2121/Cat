local node = cat.require"module/game/scene/node/node"

local node = cat.object("psoition_node",node){
    position = nil,
    _root = nil,
    _child = {},
}

function node:__init__(x,y)
    node.__init__(self)
    self.position = cat.position(x,y)
    self:connect("exit_scene",self,"__exit_scene__")
end

function node:set_root(node)
    if node == nil then return end
    if self._root == node then return else
        self:clear_root()
    end
    self.position:set_root(node.position)
    self._root = node
    node._child[self.name] = self
    return self
end

function node:clear_root()
    self._root._child[self.name] = nil
    self._root = nil
    return self
end

function node:__exit_scene__()
    self:clear_root()
end

function node:get_chile(name)
    return self._child[name]
end

function node:add_child(child)
    child:clear_root()--一个节点只能有一个根,添加已经根的节点会删除原来的
    child._root = self
    self._child[child.name] = child
    return self
end

function node:remove_child(name)
    local child = self:get_chile(name)
    if child then
        child:clear_root()
    end

    return self
end

function node:get_position()
    return self.position:unpack()
end

return node

