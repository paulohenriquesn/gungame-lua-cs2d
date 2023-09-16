local playerService = require("sys/lua/src/services/player")

function onDieHook(playerId)
    playerService:onDie(playerId)
end

addhook('die', 'onDieHook')
