Player = class(AnimatedObject)


function Player:init()
    imgList = {"plane0", "plane1", "plane2", "plane1"}
    AnimatedObject.init(self, imgList)

    self.animationSpeed = 5 / 60
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
    AnimatedObject.update(self, dt)

    -- Movement.
    self.vy = self.vy + self.gravity
    local rAim = self.vy / 1000
    if self.vy < 0 then
        self.r = self.r - 0.1
        if self.r < rAim then self.r = rAim end
    else
        self.r = rAim
    end
end

function Player:up()
    self.vy = - 300
end

function Player:collide()
    -- body
end

function Player:checkCollision(o, sx)
    if AnimatedObject.checkCollision(self, o) then
        for _, p in pairs(self.collisionPoints) do
            local x, y = self:toWorld(p.x, p.y)
            x = (x - o.x) / o.scale_w + o.ox
            y = (y - o.y) / o.scale_h + o.oy
            x = math.floor(x)
            y = math.floor(y)


            if x >= 0 and x < o.img_w and y >= 0 and y < o.img_h then
                r, g, b, a = o.img:getData():getPixel(x, y)

                if a >= 128 then
                    --self.queue:push({x = p.x, y = p.y})
                    return true
                end
            end
        end

        --if self.queue:size() > 0 then return true end
    end

    return false
end

function Player:toWorld(x, y)
    x = (x * self.scale_w) - self.w / 2
    y = (y * self.scale_h) - self.h / 2
    local sin = math.sin(self.r)
    local cos = math.cos(self.r)
    x, y = cos*x - sin*y, sin*x + cos*y
    x, y = self.x + x + self.w / 2, self.y + y + self.h / 2

    return x, y
end

function Player:draw()
    --AnimatedObject.draw(self)
    love.graphics.setColor(self.color)
    love.graphics.draw(self.img, self.x + self.w/2, self.y + self.h/2,
        self.r, self.scale_w, self.scale_h,
        self.ox + self.img_w/2, self.oy + self.img_h/2)

    --[[ Draw collision points.
    love.graphics.setPointSize(10)
    love.graphics.setColor(0, 0, 250)
    for _, p in pairs(self.collisionPoints) do
        local x, y = self:toWorld(p.x, p.y)
        love.graphics.points(x, y)
    end

    love.graphics.setPointSize(15)
    love.graphics.setColor(0, 255, 0)
    for i = self.queue.first, self.queue.last do
        p = self.queue:pop()
        local x, y = self:toWorld(p.x, p.y)
        love.graphics.points(x, y)
    end
    --]]
end
