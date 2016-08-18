
require "class"
require "world_object"
require "screen"
require "background"
require "player"
require "wall"

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
               back   = "images/back.png",
           	   wall   = "images/wall0.png",
           	   mountain1 = "images/mountain0.png",
           	   mountain2 = "images/mountain1.png"}
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

    player = Player(120, 100)
    player:setPosition(100, 0)

    wall1 = Wall(images["wall"])
    wall1:setSize(W,200)
    wall1:setPosition(0,H-200)

    wall2 = Wall(images["wall"])
    wall2:setSize(W,200)
    --wall2:setPosition(W/2,H/2)
    wall2.scale_h = -wall2.scale_h
    wall2.oy = wall2.img_h
    wall2.x = love.math.random() * W
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
