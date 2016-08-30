

AnimatedObject = class(WorldObject)


function AnimatedObject:init(imgList)
	self.imgIdx = 1
    self.imgListSize = #imgList
    self.imgList = imgList

    self.time = 0
    self.animationSpeed = 1  -- in seconds

	WorldObject.init(self, images[self.imgList[self.imgIdx]])
end


function AnimatedObject:update(dt)
	WorldObject.update(self, dt)

    self.time = self.time + dt
    if self.time > self.animationSpeed then
        self.time = self.time - self.animationSpeed
        self.imgIdx = self.imgIdx % self.imgListSize + 1
        self:setImage(images[self.imgList[self.imgIdx]])
    end
end
