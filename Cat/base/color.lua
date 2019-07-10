local COLOR_DIV = cat.COLOR_DIV

function cat.color_rgba(r,g,b,a)
    return r * COLOR_DIV,g * COLOR_DIV,b * COLOR_DIV,a * COLOR_DIV
end

function cat.color_hsv(h,s,v,a)
    a = a or 255
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return ((r+m)*255) * COLOR_DIV,((g+m)*255) * COLOR_DIV,((b+m)*255) * COLOR_DIV,a * COLOR_DIV
end

return function(r,g,b,a)
    local color = {
        r = r,
        g = g,
        b = b,
        a = a,
    }

    function color:unpack()
        return self.r,self.g,self.b,self.a
    end

    function color:to_hsv()
        return cat.color_hsv(self:unpack())
    end

    return color
end