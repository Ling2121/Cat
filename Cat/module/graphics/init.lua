local graphics = {}

function graphics.draw(assets_name,...)
    local assets = cat.assets.image(assets_name)
    if assets then
        love.graphics.draw(assets,...)
    end
end

return graphics