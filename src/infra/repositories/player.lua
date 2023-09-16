require("sys/lua/libs/sqlite")

local Player = require("sys/lua/src/domain/entities/player")
local db = sqlite3.open("sys/lua/database.db");

local PlayerRepository = {}

function PlayerRepository:incrementLevel(strategy)
        do
            db:exec('UPDATE players SET level = level + 1 WHERE '..strategy['provider']..' = '..strategy['value'])
        end
end

function PlayerRepository:incrementExp(strategy)
    do
        db:exec('UPDATE players SET exp = exp + 1 WHERE '..strategy['provider']..' = '..strategy['value'])
    end
end

function PlayerRepository:decrementExp(strategy)
    do
        db:exec('UPDATE players SET exp = exp - 1 WHERE '..strategy['provider']..' = '..strategy['value'])
    end
end

function PlayerRepository:decrementLevel(strategy)
    do
        db:exec('UPDATE players SET level = level - 1 WHERE '..strategy['provider']..' = '..strategy['value'])
    end
end


function PlayerRepository:clearExp(strategy)
    do
        db:exec('UPDATE players SET exp = 0 WHERE '..strategy['provider']..' = '..strategy['value'])
    end
end

function PlayerRepository:incrementKills(strategy)
    do
        db:exec('UPDATE players SET kills = kills + 1 WHERE '..strategy['provider']..' = '..strategy['value'])
    end
end

function PlayerRepository:incrementDeaths(strategy)
    do
        db:exec('UPDATE players SET deaths = deaths + 1 WHERE '..strategy['provider']..' = '..strategy['value'])
    end
end

function PlayerRepository:saveLastWeapon(strategy, weaponId)
    do
        db:exec('UPDATE players SET last_weapon_id = '..weaponId..' WHERE '..strategy['provider']..' = '..strategy['value'])
    end
end

function PlayerRepository:findOne(strategy)
    local entity = {}

    for player in db:rows('SELECT * FROM players WHERE '..strategy['provider']..' = '..strategy['value'])
    do
       entity = Player:create(player[1], player[2], player[3], player[4], player[5], player[6], player[7], player[8], player[9], player[10])
    end

    return entity
end

function PlayerRepository:save(strategy)
   do 
        db:exec('INSERT INTO players('..strategy['provider']..') VALUES ('..strategy['value']..')')
   end
end

return PlayerRepository
