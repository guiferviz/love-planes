
require "class"
require "world_object"
require "screen"
require "background"
require "player"

---------------------
-- Game properties --
---------------------

-- Game dimensions.
W = 1280
H = 720

state = "game"

gravity = 9.8

-- Key: image id    Value: image path
imagesPaths = {plane0 = "images/plane0.png",
               plane1 = "images/plane1.png",
               plane2 = "images/plane2.png",
               back   = "images/back.png"}
-- Key: image id    Value: love image object
images = {}


function love.load()
    -- Set screen dimensions.
    love.window.setMode(W, H, {resizable=true})
    Screen.set(W, H)

    -- Load all the images
    for k, v in pairs(imagesPaths) do
        images[k] = love.graphics.newImage(v)
    end

    back = Background(images["back"])
    back:setSize(W, H)

    player = Player()
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

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(love.timer.getFPS())

    Screen.drawBorders()
end

function love.mousereleased(x, y, button, istouch)
    if state == "menu" then
        state = "game"
    elseif state == "game" then
        player:up()
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
