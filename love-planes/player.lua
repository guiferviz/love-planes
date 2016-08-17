Player = class(WorldObject)


function Player:init(img, width, height)
    WorldObject.init(self,img, width, height)
    self.frame = 0
    self.gravity = gravity
    self.yspeed = 0
    self.img0 = love.graphics.newImage("images/plane0.png")
    self.img1 = love.graphics.newImage("images/plane1.png")
    self.img2 = love.graphics.newImage("images/plane2.png")
    --self.imgv = {love.graphics.newImage("images/plane0.png"),love.graphics.newImage("images/plane1.png"),love.graphics.newImage("images/plane2.png")}
end

function Player:update(dt)
    print("Actuliza")
    WorldObject.update(self,dt)
    --movimiento
    self.yspeed = self.yspeed + self.gravity
    self.y = self.y + self.yspeed * dt

    --Helices
    self.frame = self.frame + 60 * dt --60 porque normalmente dt * 60 = 1


    if self.frame < 15 then
        self.img = self.img0
    elseif self.frame < 30 then
        self.img = self.img1
    elseif self.frame < 45 then
        self.img = self.img2
    else
        self.img = self.img1
        self.frame = 0
    end
    
end

function Player:up(jump)
    self.yspeed = -240
end

