cat = {
	PATH = (...).."/",
	COLOR_MODE = 255,-- 255:0~255  1:0~1
	COLOR_DIV = 1 / 255,
	LOVE_CALLBACK = {
		"update",
		"draw",
		"keypressed",
		"keyreleased",
		"mousemoved",
		"mousepressed",
		"mousereleased",
		"wheelmoved",
		"textedited",
		"textinput",
	},
}

--导入cat模块
function cat.require(path)
	return require(cat.PATH..path)
end

function cat.init_base()
	cat.class  = cat.require("base/class")
	cat.object = cat.require("base/object")
	cat.color  = cat.require("base/color")
	cat.position = cat.require("base/position")
end

function cat.init_module()
	cat.bump = cat.require("module/bump")
	cat.scene = cat.require("module/scene")
	cat.game_run = cat.require("module/game_run")
end

function cat.init()
	cat.LOVE_COLOR_MODE = love._version_major
	if cat.LOVE_COLOR_MODE < 11 then
		cat.COLOR_DIV = 1
	end
	cat.init_base()
	cat.init_module()
	return cat
end

return cat.init()

