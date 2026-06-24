--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
	-- has boomerang
	self.hasBoomerang = false
	-- has thrown boomerang
	self.threwBoomerang = false
	self.boomerang = nil
end

function Player:update(dt)
	Entity.update(self, dt)
	if self.hasBoomerang and self.threwBoomerang then
		self.boomerang:update(dt)
	end
end

function Player:collides(target)
	local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2

	return not (
		self.x + self.width < target.x
		or self.x > target.x + target.width
		or selfY + selfHeight < target.y
		or selfY > target.y + target.height
	)
end

function Player:render()
	Entity.render(self)
	if self.hasBoomerang and self.threwBoomerang then
		self.boomerang:render(0, 0)
	end
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end