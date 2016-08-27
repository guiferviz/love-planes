
require "class"
require "world_object"
require "animated_object"
require "screen"
require "background"
require "player"
require "wall"
require "queue"
bitser = require "bitser"
flux = require "flux"

---------------------
-- Game properties --
---------------------

SAVE_FILENAME = "score"

-- Game dimensions.
W = 1280
H = 720

state = "menu"

gravity = 9.8 * 2

save = {bestScore = 0}
score = 0

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
               no_click = "images/no_click.png",
               numbers = "images/numbers.png",
               letters = "images/letters.png"}
-- Key: image id    Value: love image object
images = {}
seed = os.time()


function loadGameData()
    if love.filesystem.exists(SAVE_FILENAME) then
        local saveRead = love.filesystem.read(SAVE_FILENAME)
        save = bitser.loads(saveRead)
    end
end

function saveGameData()
    local saveDump = bitser.dumps(save)
    love.filesystem.write(SAVE_FILENAME, saveDump)
end

function love.load()
    loadGameData()

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
    ready:setPosition(W/2, H/2)
    ready.ox = ready.img_w / 2
    ready.oy = ready.img_h / 2

    tap = AnimatedObject{"click", "no_click"}
    tap:setPosition(W/2 - tap.img_w/2, H * 2/3 - 40)

    --Music
    music = love.audio.newSource("sounds/Good-Morning-Doctor-Weird.mp3") -- if "static" is omitted, LÖVE will stream the file from disk, good for longer music tracks
    music:setLooping(true)
    music:play()

    -- Fonts
    fontNumbers = love.graphics.newImageFont(images["numbers"], "0123456789", 10)
    fontLetters = love.graphics.newImageFont(images["letters"], "abcdefghijklmnopqrstuvwxyz ")

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

    ready.animate = true
    animateReady()

    -- Save score
    if score > save.bestScore then
        save.bestScore = math.floor(score)
        saveGameData()
    end
end

function startGame()
    state = "game"

    ready.animate = false
    wall1.probability = 0.01
    wall2.probability = 0.01
    player.gravity = gravity
    score = 0
end

function love.resize(w, h)
    Screen.set(W, H)
end

function love.update(dt)
    flux.update(dt)

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

    love.graphics.setNewFont(35)
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
    tap:update(dt)
end

function updateGame(dt)
    score = score + dt * 2
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
    tap:draw()

    love.graphics.push()
    love.graphics.setFont(fontNumbers)
    love.graphics.setColor(255, 255, 255)
    local scale = 0.4
    love.graphics.scale(scale, scale)
    width = fontNumbers:getWidth(math.floor(save.bestScore))
    love.graphics.print(math.floor(save.bestScore), (W/2)/scale - width/2, H/scale - 200)
    love.graphics.setFont(fontLetters)
    width = fontLetters:getWidth("best score")
    love.graphics.print("best score", (W/2)/scale - width/2, H/scale - 350)
    love.graphics.pop()
end

function drawGame()
    back:draw()
    wall1:draw()
    wall2:draw()
    player:draw()

    if score ~= 0 then
        love.graphics.push()
        love.graphics.setFont(fontNumbers)
        love.graphics.setColor(255, 255, 255)
        local scale = 0.5
        love.graphics.scale(scale, scale)
        widthScore = fontNumbers:getWidth(math.floor(score))
        love.graphics.print(math.floor(score), W*2-widthScore-100, 100)
        love.graphics.pop()
    end
end

--[[
    Animate the ready object while ready.animate is true.
--]]
function animateReady()
    if not ready.animate then return end
    local scale = 0.95
    local speed = 0.5
    local r = love.math.random() < 0.5 and -0.1 or 0.1

    ready.tween = flux.to(ready, speed, {scale_w = ready.scale_w * scale, scale_h = ready.scale_h * scale})
        :delay(3)
        :after(speed, {scale_w = ready.scale_w, scale_h = ready.scale_h})
        :after(speed  * 2, {r = r})
        :delay(3)
        :ease("elasticinout")
        :after(speed * 2, {r = ready.r})
        :ease("elasticinout")
        :oncomplete(animateReady)
end
