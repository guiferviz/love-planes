

Walls = class()


function Walls:init()
    self.vx = -300
    self.mountainsUp = Queue()
    self.mountainsDown = Queue()
    self.wallUp = Background(images["wall"])
    self.wallUp:setSize(W, 150)
    self.wallUp:setPosition(-love.math.random() * W, 0)
    self.wallUp.scale_h = -self.wallUp.scale_h
    self.wallUp.oy = self.wallUp.img_h
    self.wallUp.vx = self.vx

    self.wallDown = Background(images["wall"])
    self.wallDown:setSize(W, 150)
    self.wallDown:setPosition(-love.math.random() * W, H - self.wallDown.h)
    self.wallDown.vx = self.vx

    self.minDist = 200
    self.minMountainW = 100
    self.minMountainH = 200
    self.rangeMountainW = 75 * 1.2
    self.rangeMountainH = 150 * 1.2
    self.probability = 0.01

    self.woAux = WorldObject(images["wall"])
end

local function deleteMountain(mountains)
    local first = mountains.queue[mountains.first]

    if first and first.x < 0 - first.w  then
        mountains:pop()
    end
end

local function distance(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

function Walls:update(dt)
    self.wallUp:update(dt)
    self.wallDown:update(dt)

    deleteMountain(self.mountainsUp)
    deleteMountain(self.mountainsDown)

    if love.math.random() < self.probability then 
        local lastDown = self.mountainsDown.queue[self.mountainsDown.last]
        local lastUp = self.mountainsUp.queue[self.mountainsUp.last]
        if not lastUp or lastUp.x + self.minDist < W then
            local r = love.math.random()
            local w = self.minMountainW + r * self.rangeMountainW
            local h = self.minMountainH + r * self.rangeMountainH
            dist = 100000
            if lastDown then
                dist = distance(lastDown.x + lastDown.w/2, lastDown.y,
                            W + w/2, h)
            end
            if dist > self.minDist then
                local mountain = WorldObject(images["mountain0"], w, h)
                mountain.vx = self.vx
                mountain.scale_h = -mountain.scale_h
                mountain:setPosition(W, 0)
                mountain.oy = mountain.img_h
                self.mountainsUp:push(mountain)
            end
        end
    end

    if love.math.random() < self.probability then
        local lastDown = self.mountainsDown.queue[self.mountainsDown.last]
        local lastUp = self.mountainsUp.queue[self.mountainsUp.last]
        if not lastDown or lastDown.x + self.minDist < W then
            local r = love.math.random()
            local w = self.minMountainW + r * self.rangeMountainW
            local h = self.minMountainH + r * self.rangeMountainH
            dist = 100000
            if lastUp then
                dist = distance(lastUp.x + lastUp.w/2, lastUp.y + lastUp.h,
                            W + w/2, h)
            end
            if dist > self.minDist then
                local mountain = WorldObject(images["mountain0"], w, h)
                mountain.vx = self.vx
                mountain:setPosition(W, H - mountain.h)
                self.mountainsDown:push(mountain)
            end
        end
    end

    for i = self.mountainsUp.first, self.mountainsUp.last do
        self.mountainsUp.queue[i]:update(dt)
    end

    for i = self.mountainsDown.first, self.mountainsDown.last do
        self.mountainsDown.queue[i]:update(dt)
    end
    --[[
    --]]
end

function Walls:draw()
    self.wallUp:draw()
    self.wallDown:draw()

    for i = self.mountainsUp.first, self.mountainsUp.last do
        self.mountainsUp.queue[i]:draw()
    end

    for i = self.mountainsDown.first, self.mountainsDown.last do
        self.mountainsDown.queue[i]:draw()
    end
end

function Walls:checkCollision(o)
    --[[
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

    --]]
    return false
end
