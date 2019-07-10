--[[
Copyright (c) 2011 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--
local shape = cat.require("module/bump/shape/shape")
local convex_polygon_shape = cat.require("module/bump/shape/convex_polygon_shape")
local vector = cat.require("module/bump/vector-light")

local concave_polygon_shape = cat.class("concave_polygon_shape",shape){
    _polygon = nil,
    _shapes = nil,
}

function concave_polygon_shape:__init__(poly)
    shape.__init__(self, 'compound')
	self._polygon = poly
	self._shapes = poly:split_convex()
	for i,s in ipairs(self._shapes) do
		self._shapes[i] = convex_polygon_shape(s)
	end
end

function concave_polygon_shape:collides_with(other)
	if self == other then return false end
	if other._type == 'point' then
		return other:collides_with(self)
	end

	-- TODO: better way of doing this. report all the separations?
	local collide,dx,dy = false,0,0
	for _,s in ipairs(self._shapes) do
		local status, sx,sy = s:collides_with(other)
		collide = collide or status
		if status then
			if math.abs(dx) < math.abs(sx) then
				dx = sx
			end
			if math.abs(dy) < math.abs(sy) then
				dy = sy
			end
		end
	end
	return collide, dx, dy
end

function concave_polygon_shape:contains(x,y)
	return self._polygon:contains(x,y)
end

function concave_polygon_shape:intersects_ray(x,y, dx,dy)
	return self._polygon:intersects_ray(x,y, dx,dy)
end

function concave_polygon_shape:intersections_with_ray(x,y, dx,dy)
	return self._polygon:intersections_with_ray(x,y, dx,dy)
end

function concave_polygon_shape:center()
	return self._polygon.centroid.x, self._polygon.centroid.y
end

function concave_polygon_shape:get_position()
	return self._polygon.centroid
end

function concave_polygon_shape:outcircle()
	local cx,cy = self:center()
	return cx,cy, self._polygon._radius
end

function concave_polygon_shape:bbox()
	return self._polygon:bbox()
end

function concave_polygon_shape:set_root(shape)
	self._polygon:set_root(shape)
	for _,p in ipairs(self._shapes) do
		p:set_root(shape)
	end
end

function concave_polygon_shape:scale(s)
	assert(type(s) == "number" and s > 0, "Invalid argument. Scale must be greater than 0")
	local cx,cy = self:center()
	self._polygon:scale(s, cx,cy)
	for _, p in ipairs(self._shapes) do
		local dx,dy = vector.sub(cx,cy, p:center())
		p:scale(s)
		p:moveTo(cx-dx*s, cy-dy*s)
	end
end

function concave_polygon_shape:draw(mode, wireframe)
	local mode = mode or 'line'
	if mode == 'line' then
		love.graphics.polygon('line', self._polygon:unpack())
		if not wireframe then return end
	end
	for _,p in ipairs(self._shapes) do
		love.graphics.polygon(mode, p._polygon:unpack())
	end
end

return concave_polygon_shape