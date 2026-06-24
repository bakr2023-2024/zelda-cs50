--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
PlayerIdlePotState = Class({ __includes = BaseState })
function PlayerIdlePotState:init(entity, dungeon)
	self.entity = entity
	self.dungeon = dungeon
	self.entity:changeAnimation("pot-idle-" .. self.entity.direction)
end
function PlayerIdlePotState:enter(params)
	-- render offset for spaced character sprite (negated in render function of state)
	self.pot = params.pot
	self.entity.offsetY = 5
	self.entity.offsetX = 0
end

function PlayerIdlePotState:update(dt)
	-- if arrow key is pressed, transition to pot-walk state
	if
		love.keyboard.isDown("left")
		or love.keyboard.isDown("right")
		or love.keyboard.isDown("up")
		or love.keyboard.isDown("down")
	then
		self.entity:changeState("pot-walk", { pot = self.pot })
	end
	-- if enter was pressed while carrying a pot, throw it as a projectile
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		gSounds["hit-player"]:play()
		self.pot.projectile = Projectile({
			x = self.pot.x,
			y = self.pot.y,
			width = self.pot.width,
			height = self.pot.height,
			direction = self.entity.direction,
			speed = THROWN_POT_SPEED,
			breakable = true,
			player = self.entity,
			dungeon = self.dungeon
		})
		self.entity:changeState("idle")
	end
end
function PlayerIdlePotState:render()
	local anim = self.entity.currentAnimation
	-- render the pot above the player to appear as if being carried
	self.pot:render(0, -self.entity.height / 2)
	love.graphics.draw(
		gTextures[anim.texture],
		gFrames[anim.texture][anim:getCurrentFrame()],
		math.floor(self.entity.x - self.entity.offsetX),
		math.floor(self.entity.y - self.entity.offsetY)
	)

	-- debug code
	-- love.graphics.setColor(255, 0, 255, 255)
	-- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
	-- love.graphics.setColor(255, 255, 255, 255)
end
