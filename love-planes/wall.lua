Wall = class(Background)

function Wall:init(...)
    Background.init(self, ...)

    self.vx = -300
end