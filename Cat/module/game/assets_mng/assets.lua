local assets = cat.class("assets"){
    type = nil,
    _assets = {}
}

local function args(a,b,c)
	if type(b) == "table" then
		return a,a,b
	end
	return a,b,c
end

function assets:__init__(type,load_func)
    self.type = type
    if type(load_func) == "function" then
        self.load = load_func
    end


    self.__call = function(self,path)
        return self._assets[path]
    end
end

function assets:load(path,config) 
    --path 资源路径
    --config 加载方式配置
end

function assets:add_assets(a,b,c)
    local name,path,config = args(a,b,c)
    self._assets[name] = self:load(path,config)
    return self
end

function assets:add_assets_from_list(list,config)
    --list = {
    --    {name,path} or {path}
    --}
    for i,ass in ipairs(list) do
        self:add_assets(unpack(ass))
    end
    return self
end

function assets:assets(name_or_path)
    return self._assets[name_or_path]
end
    
return assets
