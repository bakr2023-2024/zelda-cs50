--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
	["switch"] = {
		type = "switch",
		texture = "switches",
		frame = 2,
		width = 16,
		height = 16,
		solid = false,
		consumable = false,
		defaultState = "unpressed",
		states = {
			["unpressed"] = {
				frame = 2,
			},
			["pressed"] = {
				frame = 1,
			},
		},
	},
	-- heart consumable that restores health
	["heart"] = {
		type = "heart",
		texture = "hearts",
		frame = 5,
		width = 16,
		height = 16,
		solid = false,
		consumable = true,
		defaultState = "heart",
		states = { ["heart"] = { frame = 5 } },
	},
    -- pot object
	["pot"] = {
		type = "pot",
		texture = "tiles",
		frame = 110,
		width = 16,
		height = 16,
		solid = true,
		consumable = false,
		defaultState = "pot",
		states = { ["pot"] = { frame = 110 } },
	},
	-- chest object
	['chest'] = {
		type='chest',
		texture = "tiles",
		frame = 167,
		width = 16,
		height = 16,
		solid = true,
		consumable = false,
		defaultState = "chest",
		states = { ["chest"] = { frame = 167 } },
	},
	['boomerang'] = {
				type='boomerang',
		texture = "boomerang",
		frame = 1,
		width = 16,
		height = 16,
		solid = false,
		consumable = false,
		defaultState = "boomerang",
		states = { ["boomerang"] = { frame = 1 } },
	}
}
