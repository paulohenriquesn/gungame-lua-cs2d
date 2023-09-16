local GameService = require("sys/lua/src/services/game")

function onSayHook(playerId, message)
    if message == '!reload' then
        GameService:reload()
        return 1
    end
end

addhook('say', 'onSayHook')
