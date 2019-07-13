local assets = cat.require"module/game/assets_manager/assets"

local assets_manager = cat.class("assets_manager"){
    image = nil,
    audio = nil,
    font = nil,
}

function assets_manager:__init__()
    self:add_assets_type("image",function(self,path,config)
        config = config or {}
        config.filter_mode = config.filter_mode or "nearest" -- or "linear"
        love.graphics.setDefaultFilter(config.filter_mode)
        return love.graphics.newImage(path)
    end)

    self:add_assets_type("audio",function(self,path,config)
        config = config or {}
        config.source_type = config.source_type or "stream"
        return love.audio.newSource(path,config.source_type)
    end)

    self:add_assets_type("font",function(self,path,config)
        config = config or {}
        config.size = config.size or 12
        config.default = config.size or false
        if not config.default then
            return love.graphics.newFont(self,path,config.size)
        end

        return love.graphics.newFont(config.size)
    end)
end

function assets_manager:add_assets_type(type,load_func)
    if self[type] == nil then
        local ass = assets(type,load_func)
        ass.__call = function(self,path)
            return self._assets[path]
        end

        self[type] = ass
    end
end

return assets_manager



