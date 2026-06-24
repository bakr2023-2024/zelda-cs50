--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}
local abs = math.abs
function Projectile:init(params)
	self.sx, self.sy = params.x, params.y
	self.width, self.height = params.width, params.height
	self.direction = params.direction
	self.speed = params.speed
	self.dx = (params.direction == "left" and -1 or params.direction == "right" and 1 or 0) * params.speed
	self.dy = (params.direction == "up" and -1 or params.direction == "down" and 1 or 0) * params.speed
	self.breakable = params.breakable -- breakable like pot or unbreakable like boomerang
	self.player = params.player
	self.dungeon = params.dungeon
	self.collided = false
end

function Projectile:update(object, dt)
	if not self.collided then
		object.x = object.x + self.dx * dt
		object.y = object.y + self.dy * dt
		-- if projectile collides with wall
		if
			object.x < MAP_RENDER_OFFSET_X + TILE_SIZE
			or object.x + self.width > VIRTUAL_WIDTH - TILE_SIZE * 2
			or object.y < MAP_RENDER_OFFSET_Y + TILE_SIZE
			or object.y + self.height
				> VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE
		then
			gSounds["hit-player"]:play()
			self.collided = true
		-- if projectile travels 4 or more tiles
		elseif abs(object.x - self.sx) >= 4 * TILE_SIZE or abs(object.y - self.sy) >= 4 * TILE_SIZE then
			gSounds["hit-player"]:play()
			self.collided = true
		-- if projectile collides with an enemy
		elseif self.dungeon then
			for _, entity in ipairs(self.dungeon.currentRoom.entities) do
				if not entity.dead and entity:collides(object) then
					gSounds["hit-enemy"]:play()
					entity:damage(1)
					self.collided = true
					break
				end
			end
		end
	elseif not self.breakable then
        -- keep track of player position and move towards it until contact occurs
		self.dx = self.player.x - object.x < 0 and -self.speed or self.player.x - object.x > 0 and self.speed or 0
		self.dy = self.player.y - object.y < 0 and -self.speed or self.player.y - object.y > 0 and self.speed or 0
		object.x = object.x + self.dx * dt
		object.y = object.y + self.dy * dt
		if abs(self.player.x - object.x) < 4 and abs(self.player.y - object.y) < 4 then
			self.player.threwBoomerang = false
		end
	end
end
