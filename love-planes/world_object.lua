
--[[
        This class represents any object that can be placed in
    the world.

    Attributes:
        x (number): x coordinate.
        y (number): y coordinate.
        w (number): draw width (default: img_w).
        h (number): draw height (default: img_h).
        r (number): rotation in radians (default: 0).
        ox (number): offset x (default: 0).
        oy (number): offset y (default: 0).
        vx (number): speed x (default: 0).
        vy (number): speed y (default: 0).
        img (Image): image to draw.
        img_w (number): original image width.
        img_h (number): original image height.
        scale_w (number): x-axis scale (default: 1, i.e. w == img_w).
        scale_h (number): y-axis scale (default: 1, i.e. h == img_h).
--]]
WorldObject = class()


function WorldObject:init(img, width, height)
    self.x = 0
    self.y = 0
    self.r = 0
    self.ox = 0
    self.oy = 0
    self.vx = 0
    self.vy = 0
    self.color = {255, 255, 255, 255}

    self.img_w = 0
    self.img_h = 0
    self.img = nil
    self:setImage(img)
    
    self.w = 0
    self.h = 0
    self.scale_w = 0
    self.scale_h = 0
    width = width or self.img_w
    height = height or self.img_h
    self:setSize(width, height)
end


function WorldObject:setPosition(x, y)
    self.x = x
    self.y = y
end

function WorldObject:setImage(img)
    if type(img) == "string" then
        img = love.graphics.newImage(img)
    end
    
    self.img = img
    self.img_w = img:getWidth()
    self.img_h = img:getHeight()
end

function WorldObject:setSize(width, height)
    self.w = width
    self.h = height
    self.scale_w = width / self.img_w
    self.scale_h = height / self.img_h
end

function WorldObject:checkCollisionPoint(point)
    return (point.x >= self.x and point.x <= self.x + self.w
        and point.y >= self.y and point.y <= self.y + self.h)
end

function WorldObject:checkCollision(o)
    return self.x < o.x + o.w       and
           self.y < o.y + o.h       and
           o.x    < self.x + self.w and
           o.y    < self.y + self.h
end

function WorldObject:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.img, self.x, self.y, self.r,
            self.scale_w, self.scale_h, self.ox, self.oy)
end

function WorldObject:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end
