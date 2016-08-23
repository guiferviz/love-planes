
require "class"
require "world_object"
require "animated_object"
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

state = "menu"

gravity = 9.8 * 2

-- Key: image id    Value: image path
imagesPaths = {plane0 = "images/plane0.png",
               plane1 = "images/plane1.png",
               plane2 = "images/plane2.png",
               back   = "images/back.png",
               wall   = "images/wall0.png",
               mountain0 = "images/mountain0.png",
               mountain1 = "images/mountain1.png",
               ready = "images/ready.png",
               click = "images/click.png",
               no_click = "images/no_click.png"}
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

    ready = WorldObject(images["ready"])
    ready:setPosition(W/2 - ready.img_w/2, H/2 - ready.img_h/2)

    --Music
    music = love.audio.newSource("sounds/Good-Morning-Doctor-Weird.mp3") -- if "static" is omitted, LÖVE will stream the file from disk, good for longer music tracks
    music:setLooping(true)
    music:play()

    initGame()
end

function initGame()
    state = "menu"

    player = Player()
    player:setSize(120, 100)
    player:setPosition(100, H/4)
    player.gravity = 0

    wall1 = Wall(images["wall"])
    wall1:setSize(W, 150)
    wall1:setPosition(- love.math.random() * W, H - wall1.h)
    wall1.probability = 0

    wall2 = Wall(images["wall"])
    wall2:setSize(W, 150)
    wall2:setPosition(- love.math.random() * W, 0)
    wall2.scale_h = -wall2.scale_h
    wall2.oy = wall2.img_h
    wall2.probability = 0

    music:setPitch(1)
end

function startGame()
    state = "game"

    wall1.probability = 0.01
    wall2.probability = 0.01
    player.gravity = gravity
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
        startGame()
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
    back:update(dt)
    wall1:update(dt)
    wall2:update(dt)
    player:update(dt)
end

function updateGame(dt)
    music:setPitch(music:getPitch() + dt * 0.005)

    back:update(dt)
    wall1:update(dt)
    wall2:update(dt)
    player:update(dt)

    if wall1:checkCollision(player) or
       wall2:checkCollision(player)
    then
        initGame()
    end
end

function drawMenu()
    drawGame()

    ready:draw()
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
