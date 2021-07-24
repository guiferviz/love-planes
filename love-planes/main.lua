require "class"
require "world_object"
require "animated_object"
require "screen"
require "background"
require "player"
require "walls"
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
               letters = "images/letters.png",
               gameover = "images/game_over.png"}
-- Key: image id    Value: love image object
imagesData = {}
seed = os.time()


function loadGameData()
    if love.filesystem.getInfo(SAVE_FILENAME) then
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
    --love.window.setMode(W, H, {resizable=true, fullscreen=false})
    Screen.set(W, H)

    -- Load all the images
    for k, v in pairs(imagesPaths) do
        imagesData[k] = love.image.newImageData(v)
    end

    -- Set random seed.
    love.math.setRandomSeed(seed)

    back = Background(imagesData["back"])
    back:setSize(W, H)

    tap = AnimatedObject{"click", "no_click"}
    tap:setPosition(W/2 - tap.img_w/2, H * 2/3 - 40)

    gameover = WorldObject(imagesData["gameover"])
    gameover:setPosition(W/2, H/2)
    gameover.ox = gameover.img_w / 2
    gameover.oy = gameover.img_h / 2

    --Music
    music = love.audio.newSource("sounds/Good-Morning-Doctor-Weird.mp3", "stream")
    music:setLooping(true)
    music:play()

    -- Fonts
    fontNumbers = love.graphics.newImageFont(imagesData["numbers"],
        "0123456789", 10)
    fontLetters = love.graphics.newImageFont(imagesData["letters"],
        "abcdefghijklmnopqrstuvwxyz ")

    initGame()
end

function initGame()
    state = "menu"

    player = Player()
    player:setSize(120, 100)
    player:setPosition(100, H/4)
    player.gravity = 0

    walls = Walls()
    walls.probability = 0.0

    music:setPitch(1)

    ready = WorldObject(imagesData["ready"])
    ready:setPosition(W/2, H/2)
    ready.ox = ready.img_w / 2
    ready.oy = ready.img_h / 2
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
    for k, v in pairs(ready.tween) do
        v:stop()
    end
    ready.tween = nil
    walls.probability = 0.01
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
    elseif state == "dead" then
        drawGame()
        drawGameover()
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

function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
    end
 
    if love.load then love.load(arg) end
 
    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end
 
    local dt = 0
 
    -- Main loop time.
    while true do
        -- Process events.
        love.event.pump()
        for name, a,b,c,d,e,f in love.event.poll() do
            if name == "quit" then
                if not love.quit or not love.quit() then
                    return a
                end
            end
            love.handlers[name](a,b,c,d,e,f)
        end
 
        -- Update dt, as we'll be passing it to update
        love.timer.step()
        dt = love.timer.getDelta()
 
        -- Call update and draw
        love.update(dt)
 
        love.graphics.origin()
        love.draw()
        love.graphics.present()
 
        --love.timer.sleep(0.001)
    end
end


function updateMenu(dt)
    back:update(dt)
    walls:update(dt)
    player:update(dt)
    tap:update(dt)
end

function updateGame(dt)
    score = score + dt * 2
    music:setPitch(music:getPitch() + dt * 0.005)

    back:update(dt)
    walls:update(dt)
    player:update(dt)

    if walls:checkCollision(player) then
        state = "dead"
        flux.to(flux, 2, {}):oncomplete(initGame)
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
    walls:draw()
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

function drawGameover()
    gameover:draw()
end

--[[
    Animate the ready object while ready.animate is true.
--]]
function animateReady()
    if not ready.animate then return end
    local scale = 0.95
    local speed = 0.5
    local r = love.math.random() < 0.5 and -0.1 or 0.1

    ready.tween = {}
    ready.tween[1] = flux.to(ready, speed, {scale_w = ready.scale_w * scale, scale_h = ready.scale_h * scale})
        :delay(3)
    ready.tween[2] = ready.tween[1]
        :after(speed, {scale_w = ready.scale_w, scale_h = ready.scale_h})
    ready.tween[3] = ready.tween[2]
        :after(speed  * 2, {r = r})
        :delay(3)
        :ease("elasticinout")
    ready.tween[4] = ready.tween[3]
        :after(speed * 2, {r = ready.r})
        :ease("elasticinout")
        :oncomplete(animateReady)
end
