local graphics = {}
graphics.new_rectangle = cat.require"module/graphics/rectangle"
graphics.new_polygon = cat.require"module/graphics/polygon"
graphics.new_circle = cat.require"module/graphics/circle"
graphics.new_point = cat.require"module/graphics/point"
graphics.new_image = cat.require"module/graphics/image"

function graphics.draw(assets_name,...)
    local assets = cat.assets.image(assets_name)
    if assets then
        love.graphics.draw(assets,...)
    end
end

return graphics