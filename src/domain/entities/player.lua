local Player = {}

function Player:create(id, usgn_id, exp, level, kills, deaths, money, created_at, steam_id, last_weapon_id)
    local entity = {
        id = id,
        usgn_id = usgn_id,
        steam_id = steam_id,
        level = level,
        exp = exp,
        money = money,
        kills = kills,
        created_at = created_at,
        deaths = deaths,
        last_weapon_id = last_weapon_id
    }
    setmetatable(entity, Player)
    return entity
end

return Player