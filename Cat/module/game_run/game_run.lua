local game_run = cat.object("game_run"){
    assets = nil,
    scene = nil,
    _all_scene = {},
}

do
    for _,name in ipairs(cat.LOVE_CALLBACK) do
        game_run[name] = function(self,...)
            if self.scene then
                if self.scene[name] then
                    self.scene[name](self.scene,...)
                end
            end
        end
    end
end

function game_run:current()
    for _,name in ipairs(cat.LOVE_CALLBACK) do
        love[name] = function(...)
            self[name](self,...)
        end
    end
end

function game_run:__init__()
    self:signal("add_scene")
    self:signal("remove_scene")
    self:signal("change_scene")-- (scene,up_scene,is_external[是否是外部场景])
end

function game_run:add_scene(scene)
    if scene then
        self:emit_signal("add_scene",scene)
        self._all_scene[scene.name] = scene
    end
    return self
end

function game_run:remove_scene(name)
    if name then
        self:emit_signal("remove_scene",self._all_scene[name])
        self._all_scene[name] = nil
    end
    return self
end

function game_run:change_scene(scene_or_name)
    if scene_or_name then
        local scene = self._all_scene[scene_or_name]
        if scene ~= nil then
            self:emit_signal("change_scene",scene,self.scene,false)
            self.scene = scene
        else
            if type(scene_or_name) == "table" then
                self.scene = scene_or_name
                self:emit_signal("change_scene",scene_or_name,self.scene,true)
            end
        end
    end
    return self
end

return game_run

