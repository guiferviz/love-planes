
require "class"
require "world_object"
require "screen"


-- Game dimensions.
W = 1280
H = 720


function love.load()
    love.window.setMode(W, H, {resizable=true})
    Screen.set(W, H)
end

function love.resize(w, h)
    Screen.set(W, H)
end

function love.update(dt)
    
end

function love.draw()
    Screen.transform()

    love.graphics.setColor(100, 144, 24)
    love.graphics.rectangle("fill", 0, 0, W, H)
    love.graphics.setColor(140, 44, 24)
    love.graphics.rectangle("line", 0, 0, W/2, H/2)

    Screen.drawBorders()
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end
