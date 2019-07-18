local Shape = cat.object("base_shape"){
	_id = 0,
    _layer = 0,
    _type = "base_shape",
    _rotation = 0,
}

function Shape:__init__(type)
	self._type = type
	self._id = self
	self._layer = 0
end

function Shape:config_bump_info(id,layer)
	self._id = id or self
	self._layer = layer or 0
	return self
end

function Shape:moveTo(x,y)
	local cx,cy = self:center()
	self:move(x - cx, y - cy)
end

function Shape:rotation()
	return self._rotation
end

function Shape:rotate(angle)
	self._rotation = self._rotation + angle
end

function Shape:setRotation(angle, x,y)
	return self:rotate(angle - self._rotation, x,y)
end

return Shape
