local playerService = require("sys/lua/src/services/player")

function onSpawnHook(playerId)
    playerService:onSpawn(playerId)
end

addhook('spawn', 'onSpawnHook')
