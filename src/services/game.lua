local GameService = {}

local GameRepository = require("sys/lua/src/infra/repositories/game")

local weaponsIds = {}

function GameService:loadWeaponsAvailable()
    if #weaponsIds == 0 then
        weaponsIds = GameRepository:loadWeaponsAvailable()
    end
    return weaponsIds
end

function GameService:reload()
    weaponsIds = GameRepository:loadWeaponsAvailable()
end

return GameService