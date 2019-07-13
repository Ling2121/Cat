local node = cat.require"module/game/scene/node/node"()

local game_run = cat.game.new_game_run()
local assets = cat.game.new_assets_mng()
local scene = cat.game.new_scene()

cat.assets.image:add_assets("image_a","test/map.png")

local circ = cat.graphics.new_circle("fill",-300,-300,60):set_color(0,0,255)

local rect = cat.graphics.new_rectangle("fill",100,100,100,100):set_color(255,0,0,255)
local poly = cat.graphics.new_polygon("fill",250,100,100,250,200,250)
local img = cat.graphics.new_image("image_a",0,0)

poly:set_root(circ)

function node:draw()
    love.graphics.rectangle("fill",0,0,10,10)
end

function node:update()
    circ:set_position(scene.camera:to_camera_pos(love.mouse.getPosition()))
end

return function()

    scene:add_node(rect)
    scene:add_node(poly)
    scene:add_node(circ)
    scene:add_node(node)
    scene:add_node(img)

    scene:set_name("main_scene")
    game_run:add_scene(scene)
    game_run:change_scene("main_scene")
    game_run:current()
end