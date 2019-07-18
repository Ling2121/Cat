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
local Shape = cat.require("module/bump/Shape/Shape")
local vector = cat.require("module/bump/vector-light")
local GJK = cat.require("module/bump/gjk")

local math_min, math_sqrt, math_huge = math.min, math.sqrt, math.huge

local ConvexPolygonShape = cat.class("convex_polygon_shape",Shape){
    _polygon = nil,
}

function ConvexPolygonShape:__init__(polygon)
    Shape.__init__(self,'polygon')
    assert(polygon:isConvex(), "Polygon is not convex.")
    self._polygon = polygon
end

--
-- collision functions
--
function ConvexPolygonShape:support(dx,dy)
	local v = self._polygon.vertices
	local max, vmax = -math_huge
	for i = 1,#v do
		local d = vector.dot(v[i].x,v[i].y, dx,dy)
		if d > max then
			max, vmax = d, v[i]
		end
	end
	return vmax.x, vmax.y
end

-- collision dispatching:
-- let circle Shape or compund Shape handle the collision
function ConvexPolygonShape:collidesWith(other)
	if self == other then return false end
	if other._type ~= 'polygon' then
		local collide, sx,sy = other:collidesWith(self)
		return collide, sx and -sx, sy and -sy
	end

	-- else: type is POLYGON
	return GJK(self, other)
end

function ConvexPolygonShape:contains(x,y)
	return self._polygon:contains(x,y)
end


function ConvexPolygonShape:intersectsRay(x,y, dx,dy)
	return self._polygon:intersectsRay(x,y, dx,dy)
end


function ConvexPolygonShape:intersectionsWithRay(x,y, dx,dy)
	return self._polygon:intersectionsWithRay(x,y, dx,dy)
end

function ConvexPolygonShape:center()
	return self._polygon.centroid.x, self._polygon.centroid.y
end

function ConvexPolygonShape:outcircle()
	local cx,cy = self:center()
	return cx,cy, self._polygon._radius
end

function ConvexPolygonShape:bbox()
	return self._polygon:bbox()
end

function ConvexPolygonShape:move(x,y)
	self._polygon:move(x,y)
end

function ConvexPolygonShape:rotate(angle, cx,cy)
	Shape.rotate(self, angle)
	self._polygon:rotate(angle, cx, cy)
end

function ConvexPolygonShape:scale(s)
	assert(type(s) == "number" and s > 0, "Invalid argument. Scale must be greater than 0")
	self._polygon:scale(s, self:center())
end
function ConvexPolygonShape:draw(mode)
	mode = mode or 'line'
	love.graphics.polygon(mode, self._polygon:unpack())
end

return ConvexPolygonShape