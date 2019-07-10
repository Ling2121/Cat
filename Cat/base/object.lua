local class = cat.require("base/class")

local function new_single_signal(name)
    local single_signal = {
        name = name,
        all_connect = {}
    }

    --信号触发运行object的"func"函数
    function single_signal:connect(object,func)
        self.all_connect[func] = object
    end

    function single_signal:disconnect(func)
        self.all_connect[func] = nil
    end

    function single_signal:emit_signal(...)
        for name,object in pairs(self.all_connect) do
            local func = object[name]
            if func then
                func(object,...)
            end
        end
    end

    return single_signal
end

return function(name,ext_class)
    local object = class(name,ext_class){
        __all_signal__ = {},
    }

    --创建信号
    function object:signal(name)
        if self.__all_signal__[name] == nil then
            self.__all_signal__[name] = new_single_signal(name)
        end
    end

    --名为signal_name的信号触发时运行object的to_func函数
    function object:connect(signal_name,object,to_func)
        local object = self.__all_signal__[signal_name]
        if object then
            object:connect(object,to_func)
        end
    end

    --断开与signal_nam信号连接的名为func_name的函数
    function object:disconnect(signal_name,func_name)
        local object = self.__all_signal__[signal_name]
        if object then
            object:connect(func_name)
        end
    end

    --发送signal_name信号,...是要输入的参数
    function object:emit_signal(signal_name,...)
        local object = self.__all_signal__[signal_name]
        if object then
            object:emit_signal(...)
        end
    end

    return function(t)
        object:_extends(t)
        return object
    end
end