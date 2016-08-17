Background = class(WorldObject)


function Background:init(img, width, height)
    WorldObject.init(self,img, width, height)
end

function Background:setImage(img)
    WorldObject.setImage(self,img)
end

function Background:setSize(width, height)
     WorldObject.setSize(self,width,height)
end

function Background:draw(stepSize)
	local x = self.x
    love.graphics.setColor(self.color)

    self.x = x + stepSize
    if x > 0 then
    	x = x - self.w
        self.x = x
    end

    while x < W do
	  	love.graphics.draw(self.img, x, self.y, self.r,
	        self.scale_w, self.scale_h, self.ox, self.oy)
	   	x = x + self.w
	end 
end