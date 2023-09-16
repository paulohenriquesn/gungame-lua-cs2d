-- Libs 
dofile('sys/lua/libs/json.lua')

-- Hooks
dofile('sys/lua/src/presentation/hooks.lua')

-- GameService

local GameService = require('sys/lua/src/services/game')

GameService:loadWeaponsAvailable()