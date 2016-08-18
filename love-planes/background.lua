

Background = class(WorldObject)


function Background:init(...)
    WorldObject.init(self, ...)

    self.vx = -100
end


function Background:update(dt)
    WorldObject.update(self, dt)

    if self.x > 0 then
        self.x = self.x - self.w
    end
end

function Background:draw(stepSize)
    love.graphics.setColor(self.color)

    local x = self.x
    while x < W do
        love.graphics.draw(self.img, x, self.y, self.r,
            self.scale_w, self.scale_h, self.ox, self.oy)
        x = x + self.w
    end 
end