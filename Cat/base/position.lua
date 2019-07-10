return function(x,y,root)
    local pos = {
        root = nil,
        x = x or 0,
        y = y or 0,
    }

    function pos:set_root(root)
        if type(root) == "table" and root ~= self then
			rawset(self,"root",root)
            rawset(self,"_x",rawget(self,"x"))
            rawset(self,"_y",rawget(self,"y"))
            rawset(self,"x",nil)
            rawset(self,"y",nil)
        end
		
		return self
    end

    function pos:__index(k)
        if k == 'x' or k == 'y' then
            local v = rawget(self,"root")[k] or 0
            return rawget(self,"_" .. k) + v
        end
        return rawget(self,k)
    end

    function pos:__newindex(k,v)
        if k == 'x' or k == 'y' then
            rawset(self,"_" .. k,v)
			return
        end
        rawset(self,k,v)
    end

    function pos:unpack()
        return self.x,self.y
    end

    return setmetatable(pos,pos):set_root(root)
end