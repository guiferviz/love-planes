Wall = class(Background)

function Wall:init(...)
    Background.init(self, ...)

    self.vx = -300
    self.mountains = Queue()
    self.minDist = images["mountain0"]:getWidth() + images["mountain0"]:getWidth()/2
    self.maxDist = images["mountain0"]:getWidth() * 4
    self.probability = 0.01
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
			local mountain = WorldObject(images["mountain0"], 100 + r * 50, 200 + r * 100)
			mountain.vx = self.vx
			if self.scale_h < 0 then
				mountain.scale_h = -mountain.scale_h
				mountain:setPosition(W, mountain.h)
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