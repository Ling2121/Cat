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
local convex_polygon_shape = cat.require("module/bump/Shape/convex_polygon_shape")
local vector = cat.require("module/bump/vector-light")

local ConcavePolygonShape = cat.class("concave_polygon_shape",Shape){
    _polygon = nil,
    _shapes = nil,
}

function ConcavePolygonShape:__init__(poly)
    Shape.__init__(self, 'compound')
	self._polygon = poly
	self._shapes = poly:splitConvex()
	for i,s in ipairs(self._shapes) do
		local sp = convex_polygon_shape(s)
		self._shapes[i] = sp
	end
end

function ConcavePolygonShape:collidesWith(other)
	if self == other then return false end
	if other._type == 'point' then
		return other:collidesWith(self)
	end

	-- TODO: better way of doing this. report all the separations?
	local collide,dx,dy = false,0,0
	for _,s in ipairs(self._shapes) do
		local status, sx,sy = s:collidesWith(other)
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

function ConcavePolygonShape:contains(x,y)
	return self._polygon:contains(x,y)
end

function ConcavePolygonShape:intersectsRay(x,y, dx,dy)
	return self._polygon:intersectsRay(x,y, dx,dy)
end

function ConcavePolygonShape:intersectionsWithRay(x,y, dx,dy)
	return self._polygon:intersectionsWithRay(x,y, dx,dy)
end

function ConcavePolygonShape:center()
	return self._polygon.centroid.x, self._polygon.centroid.y
end

function ConcavePolygonShape:outcircle()
	local cx,cy = self:center()
	return cx,cy, self._polygon._radius
end

function ConcavePolygonShape:bbox()
	return self._polygon:bbox()
end

function ConcavePolygonShape:move(x,y)
	self._polygon:move(x,y)
	for _,p in ipairs(self._shapes) do
		p:move(x,y)
	end
end

function ConcavePolygonShape:rotate(angle,cx,cy)
	Shape.rotate(self, angle)
	if not (cx and cy) then
		cx,cy = self:center()
	end
	self._polygon:rotate(angle,cx,cy)
	for _,p in ipairs(self._shapes) do
		p:rotate(angle, cx,cy)
	end
end


function ConcavePolygonShape:scale(s)
	assert(type(s) == "number" and s > 0, "Invalid argument. Scale must be greater than 0")
	local cx,cy = self:center()
	self._polygon:scale(s, cx,cy)
	for _, p in ipairs(self._shapes) do
		local dx,dy = vector.sub(cx,cy, p:center())
		p:scale(s)
		p:moveTo(cx-dx*s, cy-dy*s)
	end
end

function ConcavePolygonShape:draw(mode, wireframe)
	local mode = mode or 'line'
	if mode == 'line' then
		love.graphics.polygon('line', self._polygon:unpack())
		if not wireframe then return end
	end
	for _,p in ipairs(self._shapes) do
		love.graphics.points(p._polygon.centroid:unpack())
		love.graphics.polygon(mode, p._polygon:unpack())
	end
end

return ConcavePolygonShape