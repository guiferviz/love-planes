Queue = class()

function Queue:init()
	self.first = 0 
	self.last = -1
	self.queue = {}
end

function Queue:push(value)
	self.last = self.last + 1
	self.queue[self.last] = value
end

function Queue:pop()
	if self:size() == 0 then
		return nil
	end

	local value = self.queue[self.first]
	self.queue[self.first] = nil
	self.first = self.first + 1
	return value	
end

function Queue:size()
	return self.last - self.first + 1
end

function Queue.peek()
	
end