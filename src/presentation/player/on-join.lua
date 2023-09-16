local playerService = require("sys/lua/src/services/player")

function onJoinHook(playerId)
    playerService:onConnect(playerId)
end

addhook('join', 'onJoinHook')
