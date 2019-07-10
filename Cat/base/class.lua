local function copy_value(value)
    if type(value) ~= "table" then
        return value
    end
    local cpt = {}
    for k,v in pairs(value) do
        cpt[copy_value(k)] = copy_value(v)
    end

    return setmetatable(cpt,value)
end

local function extends(class,ext_class)
    if ext_class == nil then
        return class
    end
    for k,v in pairs(ext_class) do
        class[copy_value(k)] = copy_value(v)
    end
    return class
end 

return function(name,ext_class)
    return function(class)
        class.__class_name__ = name
        class.__extends_class__ = ext_class
        class._extends = extends
        
        function class:__call(...)
            local instance = {}
            extends(instance,self)
            setmetatable(instance,instance)
            if instance.__init__ then
                instance:__init__(...)
            end
            return instance
        end

        class.__new = class.__call
        extends(class,ext_class)   
        return setmetatable(class,class) 
    end
end