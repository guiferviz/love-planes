Player = class(WorldObject)


function Player:init(width, height)
    self.imgIdx = 0
    self.imgListSize = 4
    self.imgList = {}
    self.imgList[0] = "plane0"
    self.imgList[1] = "plane1"
    self.imgList[2] = "plane2"
    self.imgList[3] = "plane1"

    WorldObject.init(self, images[self.imgList[self.imgIdx]], width, height)

    self.time = 0
    self.frameRate = 5 / 60  -- Animation speed.
    self.gravity = gravity
    self.collisionPoints = {{x = 195, y = 93},
                            {x = 170, y = 140},
                            {x = 170, y = 50},
                            {x = 165 , y = 7},
                            {x = 50 , y = 7},
                            {x = 5 , y = 30},
                            {x = 10 , y = 70},
                            {x = 60 , y = 145},
                            {x = 133 , y = 165},}
    --self.queue = Queue()
end

function Player:update(dt)
    WorldObject.update(self, dt)

    -- Movement.
    self.vy = self.vy + self.gravity

    -- Animate sprite.
    self.time = self.time + dt
    if self.time > self.frameRate then
        self.time = self.time - self.frameRate
        self.imgIdx = (self.imgIdx + 1) % self.imgListSize
        self:setImage(images[self.imgList[self.imgIdx]])
    end
end

function Player:up()
    self.vy = - 300
end

function Player:collide()
    -- body
end

function Player:checkCollision(o, sx)
    if WorldObject.checkCollision(self, o) then
        for _, p in pairs(self.collisionPoints) do
            local x = (self.x + (p.x * self.scale_w) - o.x) / o.scale_w + o.ox
            local y = (self.y + (p.y * self.scale_h) - o.y) / o.scale_h + o.oy
            x = math.floor(x)
            y = math.floor(y)

            if x >= 0 and x < o.img_w and y >= 0 and y < o.img_h then
                r, g, b, a = o.img:getData():getPixel(x, y)

                if a >= 128 then
                    --self.queue:push({x = self.x + (p.x * self.scale_w),
                    --                 y = self.y + (p.y * self.scale_h)})
                    return true
                end
            end
        end
    end

    return false
end

--[[ Draw collision points.
function Player:draw()
    WorldObject.draw(self)

    love.graphics.setPointSize(10)
    love.graphics.setColor(0, 0, 250)
    for _, p in pairs(self.collisionPoints) do
        local x = self.x + (p.x * self.scale_w)
        local y = self.y + (p.y * self.scale_h)
        love.graphics.points(x, y)
    end

    love.graphics.setPointSize(15)
    love.graphics.setColor(0, 255, 0)
    for i = self.queue.first, self.queue.last do
        p = self.queue:pop()
        love.graphics.points(p.x, p.y)
    end
end
--]]
