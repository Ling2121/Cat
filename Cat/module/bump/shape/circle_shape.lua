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
local Shape = cat.require("module/bump/shape/shape")
local vector = cat.require("module/bump/vector-light")

local GJK = cat.require("module/bump/gjk")

local math_min, math_sqrt, math_huge = math.min, math.sqrt, math.huge

local circle_shape = cat.class("circle_shape",Shape){
    _center = nil,
    _radius = nil,
}

function circle_shape:__init__(cx,cy, radius)
	Shape.__init__(self, 'circle')
	self._center = cat.position(cx,cy)
	self._radius = radius
end

function circle_shape:support(dx,dy)
	return vector.add(self._center.x, self._center.y,
		vector.mul(self._radius, vector.normalize(dx,dy)))
end

function circle_shape:collides_with(other)
	if self == other then return false end
	if other._type == 'circle' then
		local px,py = self._center.x-other._center.x, self._center.y-other._center.y
		local d = vector.len2(px,py)
		local radii = self._radius + other._radius
		if d < radii*radii then
			-- if circles overlap, push it out upwards
			if d == 0 then return true, 0,radii end
			-- otherwise push out in best direction
			return true, vector.mul(radii - math_sqrt(d), vector.normalize(px,py))
		end
		return false
	elseif other._type == 'polygon' then
		return GJK(self, other)
	end

	-- else: let the other shape decide
	local collide, sx,sy = other:collides_with(self)
	return collide, sx and -sx, sy and -sy
end

function circle_shape:contains(x,y)
	return vector.len2(x-self._center.x, y-self._center.y) < self._radius * self._radius
end

function circle_shape:intersections_with_ray(x,y, dx,dy)
	local pcx,pcy = x-self._center.x, y-self._center.y

	local a = vector.len2(dx,dy)
	local b = 2 * vector.dot(dx,dy, pcx,pcy)
	local c = vector.len2(pcx,pcy) - self._radius * self._radius
	local discr = b*b - 4*a*c

	if discr < 0 then return {} end

	discr = math_sqrt(discr)
	local ts, t1, t2 = {}, discr-b, -discr-b
	if t1 >= 0 then ts[#ts+1] = t1/(2*a) end
	if t2 >= 0 then ts[#ts+1] = t2/(2*a) end
	return ts
end

function circle_shape:intersects_ray(x,y, dx,dy)
	local tmin = math_huge
	for _, t in ipairs(self:intersections_with_ray(x,y,dx,dy)) do
		tmin = math_min(t, tmin)
	end
	return tmin ~= math_huge, tmin
end

function circle_shape:center()
	return self._center.x, self._center.y
end

function circle_shape:get_position()
	return self._center
end

function circle_shape:outcircle()
	local cx,cy = self:center()
	return cx,cy, self._radius
end

function circle_shape:bbox()
	local cx,cy = self:center()
	local r = self._radius
	return cx-r,cy-r, cx+r,cy+r
end

function circle_shape:move(x,y)
	self._center.x = self._center.x + x
	self._center.y = self._center.y + y
end

function circle_shape:rotate(angle, cx,cy)
	Shape.rotate(self, angle)
	if not (cx and cy) then return end
	self._center.x,self._center.y = vector.add(cx,cy, vector.rotate(angle, self._center.x-cx, self._center.y-cy))
end

function circle_shape:scale(s)
	assert(type(s) == "number" and s > 0, "Invalid argument. Scale must be greater than 0")
	self._radius = self._radius * s
end

function circle_shape:draw(mode, segments)
	love.graphics.circle(mode or 'line', self:outcircle())
end

return circle_shape