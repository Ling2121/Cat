local list = cat.require("base/list/list")

local depth_list = cat.class("depth_list"){
    __root_node = {___is_root___ = true},
    __tail_node = nil,
    __all_node = {},
    __node_number = 0,
}

depth_list.node_class = cat.class("depth_list_node"){
    __up_node__   = nil,
    __next_node__ = nil,
    __up_depth__ = 0,
    depth = 0,
}

local function ins_node(self,node)
    if self:is_empty() then
        list.insert_node_back(self,node)
    else
        local find_node = self:find(function(fnode)
            return fnode.depth >= node.depth 
        end)
        if find_node == nil then
            list.insert_node_back(self,node)
        else
            list.insert_self_up(self,find_node,node)
        end
    end
    return node
end

function depth_list:__init__()
    self.__tail_node = self.__root_node
end

function depth_list:is_empty()
    return self.__root_node.__next_node__ == nil
end

function depth_list:get_tail()
    return self.__tail_node
end

function depth_list:get_node(index)
    if index <= 0 or index > self.node_number then
        return
    end
    local node = self.__root_node
    for i = 1, index do
        node = node.__next_node__
    end
    return node
end

function depth_list:find(condition)
    if condition == nil then return end
    for node in self:items() do
        if condition(node) then
            return node
        end
    end
    return nil
end

function depth_list:_update_node_depth(node)
    local depth = node.depth
    local up_depth = node.__up_depth__
    if depth ~= up_depth then
        node.__up_depth__ = depth
        if depth > up_depth then
            local i_node = node.__next_node__
            while i_node ~= nil do
                if i_node.depth < depth then
                    list.nswap(self,i_node,node)
                end
                i_node = i_node.__next_node__
            end
        elseif depth < up_depth then
            local i_node = node.__up_node__
            while i_node ~= nil and (not i_node.___is_root___) do
                if i_node.depth > depth then
                    list.nswap(self,i_node,node)
                end
                i_node = i_node.__up_node__
            end
        end
    end
    node.__up_depth__ = depth
end

function depth_list:insert(data,depth)
    if not data then return end
    depth = depth or 0
    local node = {data = data,depth = depth}
    return ins_node(self,node)
end

function depth_list:insert_node(node,depth)
    if not node then return end
    node.depth = depth or node.depth
    return ins_node(self,node)
end

function depth_list:remove_self(node)--节点自删除
    if not node then return end
    local up = node.__up_node__
    local next = node.__next_node__

    if next == nil then
        self:remove_back()
    else
        up.__next_node__ = next
        next.__up_node__ = up
        if up.__next_node__ == nil then
            self.__tail_node = up
        end
    end
    self.__all_node[node] = nil
    self.node_num = self.node_num - 1
end

function depth_list:remove_back()
    local node = self.__tail_node
    local tail = node.__up_node__
    node.__up_node__.__next_node__ = nil
    self.__all_node[node] = nil
    self.node_num = self.node_num - 1
    self.__tail_node = tail
    return node
end

function depth_list:remove(index)
    local node = self:get_node(index)
    if node then
        local up = node.__up_node__
        local next = node.__next_node__

        up.__next_node__ = next
        if next then
            next.__up_node__ = up
        end

        self.__all_node[node] = nil
        if up.__next_node__ == nil then
            self.__tail_node = up
        end

        self.node_num = self.node_num - 1
        return node
    end
end

function depth_list:items()
    local node = self.__root_node

    return function()
        node = node.__next_node__
        return node
    end
end

return depth_list