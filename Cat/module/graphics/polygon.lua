local baseg = cat.require"module/graphics/base_graphics"

function load_vertex(vertex)
    local ver = {}
    for i = 1,#vertex,2 do
        local v = cat.position(vertex[i],vertex[i + 1])
        table.insert(ver,v)
    end
    return ver
end

function get_position(vertex)
    local min_x = math.huge
    local min_y = math.huge
    for k,ver in ipairs(vertex) do
        min_x = math.min(rawget(ver,"x"),min_x)
        min_y = math.min(rawget(ver,"y"),min_y)
    end

    return min_x,min_y
end

local polygon = cat.class("polygon",baseg){
    vertex = {},
}

function polygon:__init__(fill_mode,vertex,...)
    baseg.__init__(self,fill_mode,0,0)
    local ver = vertex
    if type(vertex) ~= "table" then ver = {vertex,...}end
    ver = load_vertex(ver)

    local x,y = get_position(ver)
    for k,ver in ipairs(ver) do
        ver.x = ver.x - x
        ver.y = ver.y - y
        ver:set_root(self.position)
    end

    self.vertex = ver
    self:set_position(x,y)
end

function polygon:unpack()
    local vertex = {}
    for _,ver in ipairs(self.vertex) do
        table.insert(vertex,ver.x)
        table.insert(vertex,ver.y)
    end
    return unpack(vertex)
end

function polygon:draw()
    love.graphics.setColor(self.color:unpack())
    love.graphics.rectangle("fill",self.position.x,self.position.y,10,10)
    love.graphics.polygon(self.fill_mode,self:unpack())
    love.graphics.setColor(255,255,255,255)
end

return polygon