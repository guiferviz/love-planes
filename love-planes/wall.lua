Wall = class(Background)

function Wall:init(...)
    Background.init(self, ...)

    self.vx = -300
    self.mountains = Queue()
    self.minDist = 200
    self.maxDist = images["mountain0"]:getWidth() * 4
    self.probability = 0.01

    self.woAux = WorldObject(...)
end

function Wall:update(dt)
    Background.update(self, dt)

    local first = self.mountains.queue[self.mountains.first]

    if first and first.x < 0 - first.w  then
        self.mountains:pop()
    end

    if love.math.random() < self.probability then 
        local last = self.mountains.queue[self.mountains.last]
        if not last or last.x + self.minDist < W then
            local r = love.math.random()
            local mountain = WorldObject(images["mountain0"],
                    100 + r * 75, 200 + r * 150)
            mountain.vx = self.vx
            if self.scale_h < 0 then
                mountain.scale_h = -mountain.scale_h
                mountain:setPosition(W, 0)
                mountain.oy = mountain.img_h
            else
                mountain:setPosition(W, H - mountain.h)
            end
            self.mountains:push(mountain)
        end
    end

    for i = self.mountains.first, self.mountains.last do
        self.mountains.queue[i]:update(dt)
    end
end

function Wall:draw()
    Background.draw(self)

    for i = self.mountains.first, self.mountains.last do
        self.mountains.queue[i]:draw()
    end
end

function Wall:checkCollision(o)
    for i = self.mountains.first, self.mountains.last do
        if o:checkCollision(self.mountains.queue[i]) then
            return true
        end
    end

    if Background.checkCollision(self, o) then
        self.woAux.y = self.y
        self.woAux.ox = self.ox
        self.woAux.oy = self.oy
        self.woAux.scale_w = self.scale_w
        self.woAux.scale_h = self.scale_h
        local x = self.x
        while x < W do
            self.woAux.x = x
            if Background.checkCollision(self.woAux, o)
                and o:checkCollision(self.woAux) then
                    return true
            end
            x = x + self.w
        end
    end

    return false
end
