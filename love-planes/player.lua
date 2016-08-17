Player = class(WorldObject)


function Player:init(img, width, height)
    WorldObject.init(self,img, width, height)
    self.frame = 0
end

function Player:update(dt)
    WorldObject.update(self,dt)
    self.y = self.y + 60 * dt
    self.frame = self.frame + 100 * dt
    if self.frame < 15 then
        self:setImage("images/plane0.png")
    elseif self.frame < 30 then
        self:setImage("images/plane1.png")
    elseif self.frame < 45 then
        self:setImage("images/plane2.png")
    else
        self:setImage("images/plane1.png")
        self.frame = 0
    end
end

function Player:up(jump)
    self.y = self.y - jump 
end

