PlayerLiftPotState = Class({ __includes = BaseState })

function PlayerLiftPotState:init(player, dungeon)
	self.player = player
	self.dungeon = dungeon
	self.player:changeAnimation("pot-lift-" .. self.player.direction)
end

function PlayerLiftPotState:enter(params)
	-- render offset for spaced character sprite (negated in render function of state)
	self.pot = params.pot
	self.pot.solid = false
	self.pot.x, self.pot.y = self.player.x, self.player.y
	self.player.offsetY = 5
	self.player.offsetX = 0
	gSounds["hit-player"]:play()
	self.player.currentAnimation:refresh()
end

function PlayerLiftPotState:update(dt)
	-- upon finishing the lifting animation, transition to pot-walk state
	if self.player.currentAnimation.timesPlayed > 0 then
		self.player.currentAnimation.timesPlayed = 0
		self.player:changeState("pot-idle", { pot = self.pot })
	end
end

function PlayerLiftPotState:render()
	local anim = self.player.currentAnimation
	love.graphics.draw(
		gTextures[anim.texture],
		gFrames[anim.texture][anim:getCurrentFrame()],
		math.floor(self.player.x - self.player.offsetX),
		math.floor(self.player.y - self.player.offsetY)
	)
end
