return function()
    --local world = cat.bump.new_world()
    local obj_a = cat.bump.new_rectangle(100,100,100,100)

    local obj_b = cat.bump.new_polygon(100,100,149,41,185,193,144,136,25,118)
    --obj_b:set_root(obj_a)

    obj_b:rotate(math.rad(90))

    

    local obj_c = cat.bump.new_rectangle(100,300,100,300)

    --world:add(obj_a,obj_a:bbox())


    local ikd = love.keyboard.isDown
    function love.update(dt)
        
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


        -- obj_a._polygon.centroid.x = obj_a._polygon.centroid.x + vx * dt
        -- obj_a._polygon.centroid.y = obj_a._polygon.centroid.y + vy * dt
        obj_a:rotate(dt)
        obj_b:rotate(dt)
        --obj_a:move(vx * dt,vy * dt)
    end

    love.graphics.setPointSize(5)

    function love.draw()
        obj_a:draw()
        -- if obj_b:collidesWith(obj_c) then
        --     love.graphics.setColor(0,255,0,255)
        -- end
        obj_b:draw("line",true)
        -- if obj_a:collidesWith(obj_c) then
        --     love.graphics.setColor(255,0,0,255)
        -- end
        -- obj_c:draw()
        -- love.graphics.setColor(255,255,255,255)

        love.graphics.points(obj_a._polygon.centroid:unpack())
        -- love.graphics.points(obj_b._polygon.centroid:unpack())
    end
end