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
	-- if 'E' key is pressed and the player has the boomerang and didn't throw it yet
	if love.keyboard.wasPressed("e") and self.entity.hasBoomerang then
		if not self.entity.threwBoomerang then
			self.entity.threwBoomerang = true
			-- set position of boomerang to player current position and direction of projectile according to player direction
			self.entity.boomerang.x, self.entity.boomerang.y = self.entity.x, self.entity.y
			self.entity.boomerang.projectile = Projectile({
				x = self.entity.boomerang.x,
				y = self.entity.boomerang.y,
				width = self.entity.boomerang.width,
				height = self.entity.boomerang.height,
				direction = self.entity.direction,
				speed = BOOMERANG_SPEED,
				breakable = false,
				player = self.entity,
				dungeon = self.dungeon,
			})
		end
	end
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		for _, object in ipairs(self.dungeon.currentRoom.objects) do
			local dx, dy = self.entity.x - object.x, self.entity.y - object.y
			-- if enter was pressed while facing an object that can be interacted with (pot,chest)
			if (object.type == "pot" or object.type=='chest') and abs(dx) <= object.width + 4 and abs(dy) <= object.height + 4 + 3 then
				if
					((dx <= 0 and dx >= -object.width - 4) and self.entity.direction == "right")
					or ((dx >= 0 and dx <= object.width + 4) and self.entity.direction == "left")
					or ((dy <= 0 and dy >= -object.height - 4 - 3) and self.entity.direction == "down")
					or ((dy >= 0 and dy <= object.height + 4 - 3) and self.entity.direction == "up")
				then
					-- if its a pot, transition to pot-lift state
					if object.type == "pot" then
						self.entity:changeState("pot-lift", { pot = object })
					--if its a chest, open it and acquire the boomerang
					elseif object.type == "chest" and not self.entity.hasBoomerang then
						gSounds["hit-player"]:play()
						self.entity.hasBoomerang = true
						self.entity.boomerang = GameObject(GAME_OBJECT_DEFS["boomerang"], self.entity.x, self.entity.y)
					end
				end
				break
			end
		end
	end
end