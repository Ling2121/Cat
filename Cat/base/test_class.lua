cat = {}
cat.class = require"class"

function time(name,func)
    print("-----------------------------")
    print(name)
    local a = os.clock()
    print("stert:",a)
    func()
    local b = os.clock()
    print("end:",b)
    print("time:",b - a)
    print("-----------------------------")
end

local function new_transform()
    local transform = {
        x = 0,
        y = 0,
        radian = 0,
        scale_x = 1,
        scale_y = 1,
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

        if root ~= nil then
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
        end
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

local tf_a = new_transform()
tf_a.x = 10
tf_a.y = 20

local tf_b = new_transform()
tf_b.x = 10
tf_b.y = 20
tf_b:set_root(tf_a)

function xxx(t,num)
    local obj = new_transform()
    obj.x = 10
    obj:set_root(t)
    if num <= 0 then
        return obj
    end
    return xxx(obj,num - 1)
end

local x = xxx(new_transform(),128)

local y = xxx(new_transform(),128)

time("x",function()
    local a = x.x
    for i = 1,2000 do
        a = a + x.x
    end
end)
time("y",function()
    local x = y
    local a = x.x
    for i = 1,2000 do
        a = a + x.x
    end
end)

