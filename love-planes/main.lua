
require "class"
require "world_object"
require "screen"
require "background"
require "player"
require "wall"
require "queue"

---------------------
-- Game properties --
---------------------

-- Game dimensions.
W = 1280
H = 720

state = "game"

gravity = 9.8 * 2

-- Key: image id    Value: image path
imagesPaths = {plane0 = "images/plane0.png",
               plane1 = "images/plane1.png",
               plane2 = "images/plane2.png",
               back   = "images/back.png",
               wall   = "images/wall0.png",
               mountain0 = "images/mountain0.png",
               mountain1 = "images/mountain1.png"}
-- Key: image id    Value: love image object
images = {}
seed = 0--os.time()


function love.load()
    -- Set screen dimensions.
    love.window.setMode(W, H, {resizable=true, fullscreen=false})
    Screen.set(W, H)

    -- Load all the images
    for k, v in pairs(imagesPaths) do
        images[k] = love.graphics.newImage(v)
    end

    -- Set random seed.
    love.math.setRandomSeed(seed)

    back = Background(images["back"])
    back:setSize(W, H)

    player = Player(120, 100)
    player:setPosition(100, H/4)

    wall1 = Wall(images["wall"])
    wall1:setSize(W, 150)
    wall1:setPosition(- love.math.random() * W, H - wall1.h)

    wall2 = Wall(images["wall"])
    wall2:setSize(W, 150)
    wall2:setPosition(- love.math.random() * W, 0)
    wall2.scale_h = -wall2.scale_h
    wall2.oy = wall2.img_h

    --Music
    music = love.audio.newSource("sounds/Good-Morning-Doctor-Weird.mp3") -- if "static" is omitted, LÖVE will stream the file from disk, good for longer music tracks
    music:setLooping(true)
    music:play()
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
    back:update(dt)
    wall1:update(dt)
    wall2:update(dt)
    player:update(dt)

    if wall1:checkCollision(player) or
       wall2:checkCollision(player)
    then
        player.color = {255, 55, 55, 255}
    else
        player.color = {255, 255, 255}
    end
end

function drawMenu()
    drawGame()
end

function drawGame()
    back:draw()
    wall1:draw()
    wall2:draw()
    player:draw()
end


function moveBackground(stepSize)
    back.x = back.x - stepSize

    if back.x < -W then
        back.x = 0
    end
end
