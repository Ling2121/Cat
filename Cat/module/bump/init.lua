local _convex_polygon_shape = cat.require"module/bump/shape/convex_polygon_shape"
local _concave_polygon_shape = cat.require"module/bump/shape/concave_polygon_shape"
local _circle_shape = cat.require"module/bump/shape/circle_shape"
local _point_shape = cat.require"module/bump/shape/point_shape"
local _polygon = cat.require"module/bump/shape/polygon"
local _world = cat.require"module/bump/world"

local function new_polygon(polygon,...)
    -- create from coordinates if needed
	if type(polygon) == "number" then
		polygon = _polygon(polygon,...)
	else
		polygon = polygon:clone()
	end

	if polygon:is_convex() then
		return _convex_polygon_shape(polygon)
	end

	return _concave_polygon_shape(polygon)
end

local function new_rectangle(x,y,w,h)
    return new_polygon(
        x,y,
        x + w,y,
		x + w,y + h,
		x,y + h
    )
end

local bump = {
	new_rectangle	= new_rectangle,
    new_polygon     = new_polygon,
	new_circle      = _circle_shape,
	new_point       = _point_shape,
	new_world		= _world,
}

return bump