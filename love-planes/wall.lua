Wall = class(Background)

function Wall:init(...)
    Background.init(self, ...)

    self.vx = -300
    self.mountains = Queue()
    self.minDist = images["mountain0"]:getWidth() + images["mountain0"]:getWidth()/2
    self.maxDist = images["mountain0"]:getWidth() * 4
end

function Wall:update(dt)
	Background.update(self, dt)

	local pos = 0
	if self.mountains:size() ~= 0 then
		pos = self.mountains.queue[self.mountains.last].x
	end
	if self.mountains:size() < 10 then
		local r = love.math.random()
		local mountain = WorldObject(images["mountain0"], 100 + r * 50, 200 + r * 100)
		mountain.vx = self.vx
		mountain:setPosition(pos + self.minDist, H - mountain.h) --Añadir algo mas
		self.mountains:push(mountain)
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