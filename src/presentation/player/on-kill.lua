local playerService = require("sys/lua/src/services/player")

function onKillHook(playerId)
    playerService:onKill(playerId)
end

addhook('kill', 'onKillHook')
