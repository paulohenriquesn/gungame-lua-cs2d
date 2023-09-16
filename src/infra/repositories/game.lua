require("sys/lua/libs/sqlite")
local json = require("sys/lua/libs/json")

local db = sqlite3.open("sys/lua/database.db");

local GameRepository = {}

function GameRepository:loadWeaponsAvailable()
    local weaponsAvailable = {}
    
    for weapon in db:rows('SELECT * FROM weapons_available')
    do
      table.insert(weaponsAvailable, weapon[1])
    end
    
    print(json.encode(weaponsAvailable))
    return weaponsAvailable
end

return GameRepository