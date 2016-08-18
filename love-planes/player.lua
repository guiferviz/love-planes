Player = class(WorldObject)


function Player:init(width, height)
    self.time = 0
    self.frameRate = 5 / 60  -- Animation speed.
    self.gravity = gravity

    self.imgIdx = 0
    self.imgListSize = 4
    self.imgList = {}
    self.imgList[0] = "plane0"
    self.imgList[1] = "plane1"
    self.imgList[2] = "plane2"
    self.imgList[3] = "plane1"

    WorldObject.init(self, images[self.imgList[self.imgIdx]], width, height)
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

