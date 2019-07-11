local assets = cat.require"module/game/assets_mng/assets"

local assets_mng = cat.class("assets_mng"){
    image = nil,
    audio = nil,
    font = nil,
}

function assets_mng:__init__()
    assets_mng.image = assets("image",function(path,config)
        config = config or {}
        config.filter_mode = config.filter_mode or "nearest" -- or "linear"
        love.graphics.setDefaultFilter(config.filter_mode)
        return love.graphics.newImage(path)
    end)

    assets_mng.audio = assets("audio",function(path,config)
        config = config or {}
        config.source_type = config.source_type or "stream"
        return love.audio.newSource(path,config.source_type)
    end)

    assets_mng.font = assets("font",function(path,config)
        config = config or {}
        config.size = config.size or 12
        config.default = config.size or false
        if not config.default then
            return love.graphics.newFont(path,config.size)
        end

        return love.graphics.newFont(config.size)
    end)
end

function assets_mng:add_assets_type(type,load_func)
    if self[type] == nil then
        self[type] = assets(type,load_func)
    end
end



