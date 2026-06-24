PlayerWalkPotState = Class({ __includes = EntityWalkState })

function PlayerWalkPotState:init(entity, dungeon)
	self.entity = entity
	self.dungeon = dungeon
end

function PlayerWalkPotState:enter(params)
	-- render offset for spaced character sprite (negated in render function of state)
	self.pot = params.pot
	self.entity.offsetY = 5
	self.entity.offsetX = 0
end

function PlayerWalkPotState:update(dt)
	-- update pot position to link to entity
	self.pot.x, self.pot.y = self.entity.x, self.entity.y
	-- pressing enter will throw the pot as a projectile and transition to idle state
	if love.keyboard.isDown("left") then
		self.entity.direction = "left"
		self.entity:changeAnimation("pot-walk-left")
	elseif love.keyboard.isDown("right") then
		self.entity.direction = "right"
		self.entity:changeAnimation("pot-walk-right")
	elseif love.keyboard.isDown("up") then
		self.entity.direction = "up"
		self.entity:changeAnimation("pot-walk-up")
	elseif love.keyboard.isDown("down") then
		self.entity.direction = "down"
		self.entity:changeAnimation("pot-walk-down")
	else
		self.entity:changeState("pot-idle", { pot = self.pot })
	end
	EntityWalkState.update(self, dt)
end
function PlayerWalkPotState:render()
	-- render the pot above the player to appear as if being carried
	self.pot:render(0, -self.entity.height / 2)
	local anim = self.entity.currentAnimation
	love.graphics.draw(
		gTextures[anim.texture],
		gFrames[anim.texture][anim:getCurrentFrame()],
		math.floor(self.entity.x - self.entity.offsetX),
		math.floor(self.entity.y - self.entity.offsetY)
	)
	-- render the pot above the player to appear as if being carried
	-- debug code
	-- love.graphics.setColor(255, 0, 255, 255)
	-- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
	-- love.graphics.setColor(255, 255, 255, 255)
end
