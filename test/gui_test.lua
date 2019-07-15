local control = cat.require("module/gui/control/control")
local Box = cat.require("module/gui/control/box")
local button = cat.require("module/gui/control/button")
local scene = cat.game.new_scene()

local box = Box():config_style({
    box_color = cat.color(100,100,100,255),
    box_fill_mode = "fill",
})
local box2 = Box()

return function()
    local control_a = control(100,100,100,40)
    local button_a = button("Button_a",150,150,100,45)
    control_a._can_drag = true
    button_a._can_drag = true
    box._can_drag = true

    box2._is_select = true

    function control_a:mousepressed()
        self:drag_mousepressed()
    end

    function control_a:mousereleased()
        self:drag_mousereleased()
    end

    function control_a:update()
        --print(self._is_dragging)
        self:drag_update()
    end

    function control_a:__enter()
        print("enter")
    end

    function control_a:__exit()
        print("exit")
    end

    function button_a:click()
        print("Cilck!")
    end

    button_a:connect("mouse_press",button_a,"click")

    


    box:add_control(button_a)
    box:add_control(control_a)
    box2:add_control(box)

    scene:add_node(box2)
    --scene:add_node(control_a)
    
    scene:set_name("main_scene")
    cat.game_run:add_scene(scene)
    cat.game_run:change_scene("main_scene")
    cat.game_run:current()
end