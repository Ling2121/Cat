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
local vector = cat.require("module/bump/vector-light")

local point_shape = cat.class("point_shape",shape){
    _pos = nil,
}

function point_shape:__init__(x,y)
    shape.init(self, 'point')
	self._pos = cat.position(x,y)
end

function point_shape:collidesWith(other)
	if self == other then return false end
	if other._type == 'point' then
		return (self._pos == other._pos), 0,0
	end
	return other:contains(self._pos.x, self._pos.y), 0,0
end

function point_shape:contains(x,y)
	return x == self._pos.x and y == self._pos.y
end

-- point shape intersects ray if it lies on the ray
function point_shape:intersects_ray(x,y, dx,dy)
	local px,py = self._pos.x-x, self._pos.y-y
	local t = px/dx
	-- see (px,py) and (dx,dy) point in same direction
	return (t == py/dy), t
end

function point_shape:intersections_with_ray(x,y, dx,dy)
	local intersects, t = self:intersects_ray(x,y, dx,dy)
	return intersects and {t} or {}
end

function point_shape:center()
	return self._pos.x, self._pos.y
end

function point_shape:get_position()
	return self._pos
end

function point_shape:outcircle()
	return self._pos.x, self._pos.y, 0
end

function point_shape:bbox()
	local x,y = self:center()
	return x,y,x,y
end


function point_shape:move(x,y)
	self._pos.x = self._pos.x + x
	self._pos.y = self._pos.y + y
end

function point_shape:rotate(angle, cx,cy)
	shape.rotate(self, angle)
	if not (cx and cy) then return end
	self._pos.x,self._pos.y = vector.add(cx,cy, vector.rotate(angle, self._pos.x-cx, self._pos.y-cy))
end

function point_shape:scale()
	-- nothing
end

function point_shape:draw()
	love.graphics.point(self:center())
end

return point_shape