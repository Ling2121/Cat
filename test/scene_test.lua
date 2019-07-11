return function()
    local node = cat.require"module/game/scene/node/node"
    local object = cat.class("object",node){}

    function object:__init__()
        node.__init__(self)
        self.x = love.math.random(-1000,1000)
        self.y = love.math.random(-1000,1000)
        self.w = love.math.random(50,60)
        self.h = love.math.random(50,60)
        self.color = {
            love.math.random(0,255),
            love.math.random(0,255),
            love.math.random(0,255),
        }
        self.depth = self.y
    end

    function object:draw()
        love.graphics.setColor(unpack(self.color))
        love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
        love.graphics.setColor(255,255,255,255)
    end

    local player = cat.class("player",object){}
    local ikd = love.keyboard.isDown

    function player:update(dt)
        local vx,vy = 0,0
        if ikd("w") then
            vy = - 100
        end
        if ikd("s") then
            vy = 100
        end
        if ikd("a") then
            vx = - 100
        end
        if ikd("d") then
            vx = 100
        end
        self.x = self.x + vx * dt
        self.y = self.y + vy * dt
        self.depth = self.y

        self.at_scene.camera:lookAt(self.x,self.y)
    end

    function player:screen_draw()
        love.graphics.print(love.timer.getFPS())
    end

    local game_run = cat.game.new_game_run()
    local scene = cat.game.new_scene()

    local num = 10000

    for i = 1,num do
        scene:add_node(object())
    end

    scene:add_node(player())

    scene:set_name("main_scene")
    game_run:add_scene(scene)
    game_run:change_scene("main_scene")
    game_run:current()
end