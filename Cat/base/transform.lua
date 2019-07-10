return function(x,y,r,sx,sy)
    local transform = {
        x = x or 0,
        y = y or 0,
        radian = r or 0,
        scale_x = sx or 1,
        scale_y = sy or 1,
    }

    local tf_value = {
        x = "_x",
        y = "_y",
        radian = "_radian",
        scale_x = "_scale_x",
        scale_y = "_scale_y",
    }

    function transform:set_root(root)
        rawset(self,"root",root)
        rawset(self,"_x",rawget(self,"x"))
        rawset(self,"_y",rawget(self,"y"))
        rawset(self,"_radian",rawget(self,"radian"))
        rawset(self,"_scale_x",rawget(self,"scale_x"))
        rawset(self,"_scale_y",rawget(self,"scale_y"))
        rawset(self,"x",nil)
        rawset(self,"y",nil)
        rawset(self,"radian",nil)
        rawset(self,"scale_x",nil)
        rawset(self,"scale_y",nil)
        return self
    end

    function transform:__index(k)
        local root = rawget(self,"root")
        if root ~= nil then
            local _k = tf_value[k]
            if _k ~= nil then
                local v = rawget(self,_k)
                v = v + root[k]
                return v
            end
        end
        return rawget(self,k)
    end

    function transform:__newindex(k,v)
        local root = rawget(self,"root")
        if root ~= nil then
            local _k = tf_value[k]
            if _k ~= nil then
                rawset(self,_k,v)
            end
        end
    end

    return setmetatable(transform,transform)
end