
require "class"
require "world_object"
require "screen"
require "background"
require "player"


-- Game dimensions.
W = 1280
H = 720


-- Game properties.
state = "game"


function love.load()
    love.window.setMode(W, H, {resizable=true})
    Screen.set(W, H)

    back = Background("images/back.png")
    back:setSize(W, H)

    player = Player("images/plane0.png")
    player:setPosition(100, 0)
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
        player:up(30)
    end
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end


function updateMenu(dt)
    
end

function updateGame(dt)
    player:update(dt)
end

function drawMenu()
    drawGame()
end

function drawGame()
    back:draw(-1)
    player:draw()
end


function moveBackground(stepSize)
    back.x = back.x - stepSize

    if back.x < -W then
        back.x = 0
    end
end
