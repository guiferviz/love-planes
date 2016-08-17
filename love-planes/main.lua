
require "class"
require "world_object"
require "screen"
require "background"


-- Game dimensions.
W = 1280
H = 720


-- Game properties.
state = "menu"


function love.load()
    love.window.setMode(W, H, {resizable=true})
    Screen.set(W, H)

    back = Background("images/back.png")
    back:setSize(W, H)
end

function love.resize(w, h)
    Screen.set(W, H)
end

function love.update(dt)
    if state == "menu" then
        updateMenu(dt)
    elseif state == "game" then
        updateGame(dt)
    end
end

function love.draw()
    Screen.transform()

    if state == "menu" then
        drawMenu()
    elseif state == "game" then
        drawGame()
    end

    Screen.drawBorders()
end

function love.mousereleased(x, y, button, istouch)
    if state == "menu" then
        state = "game"
    elseif state == "game" then
        state = "menu"
    end
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end


function updateMenu(dt)
    --moveBackground(50 * dt)
end

function updateGame(dt)
    --moveBackground(150 * dt)
end

function drawMenu()
    drawGame()
end

function drawGame()
    back:draw(-1)
end


function moveBackground(stepSize)
    back.x = back.x - stepSize

    if back.x < -W then
        back.x = 0
    end
end
