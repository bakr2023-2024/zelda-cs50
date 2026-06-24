--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class({})

function GameObject:init(def, x, y)
	-- string identifying this object type
	self.type = def.type

	self.texture = def.texture
	self.frame = def.frame or 1

	-- whether it acts as an obstacle or not
	self.solid = def.solid
	-- whether it is a consumable or not
	self.consumable = def.consumable

	self.defaultState = def.defaultState
	self.state = self.defaultState
	self.states = def.states or {}
	-- dimensions
	self.x = x
	self.y = y
	self.width, self.height = def.width, def.height
	self.width2, self.height2 = def.width / 2, def.height / 2
	self.projectile = nil
	self.rotationAngle = 0
	-- default empty collision callback
	self.onCollide = function() end
	-- default empty consume callback
	self.onConsume = function() end
end

function GameObject:update(dt)
	if self.projectile then
		self.projectile:update(self, dt)
		-- update rotation angle of object if it's being thrown
		self.rotationAngle = self.rotationAngle + PROJECTILE_ROTATION_SPEED * dt
	end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
	-- apply rotation around the object center
	love.graphics.draw(
		gTextures[self.texture],
		gFrames[self.texture][self.states[self.state].frame or self.frame],
		self.x + adjacentOffsetX + self.width2,
		self.y + adjacentOffsetY + self.height2,
		self.rotationAngle,1,1,self.width2,self.height2
	)
end
