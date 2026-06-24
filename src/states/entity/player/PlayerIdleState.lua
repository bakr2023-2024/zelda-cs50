--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
local abs = math.abs
PlayerIdleState = Class({ __includes = EntityIdleState })
function PlayerIdleState:init(entity, dungeon)
	EntityIdleState.init(self, entity)
	self.dungeon = dungeon
end
function PlayerIdleState:enter(params)

	-- render offset for spaced character sprite (negated in render function of state)
	self.entity.offsetY = 5
	self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
	if
		love.keyboard.isDown("left")
		or love.keyboard.isDown("right")
		or love.keyboard.isDown("up")
		or love.keyboard.isDown("down")
	then
		self.entity:changeState("walk")
	end

	if love.keyboard.wasPressed("space") then
		self.entity:changeState("swing-sword")
	end
	-- if enter was pressed while facing a pot, transition to pot-lift state
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		for i, object in ipairs(self.dungeon.currentRoom.objects) do
			local dx, dy = self.entity.x - object.x, self.entity.y - object.y
			if object.type == "pot" and abs(dx) <= object.width + 4 and abs(dy) <= object.height + 4 + 3 then
				if
					((dx <= 0 and dx >= -object.width - 4) and self.entity.direction == "right")
					or ((dx >= 0 and dx <= object.width + 4) and self.entity.direction == "left")
					or ((dy <= 0 and dy >= -object.height - 4 - 3) and self.entity.direction == "down")
					or ((dy >= 0 and dy <= object.height + 4 - 3) and self.entity.direction == "up")
				then
					table.remove(self.dungeon.currentRoom.objects, i)
					self.entity:changeState("pot-lift", { pot = object })
				end
				break
			end
		end
	end
end