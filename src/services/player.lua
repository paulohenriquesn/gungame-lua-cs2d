local PlayerService = {}
local PlayerRepository = require("sys/lua/src/infra/repositories/player")
local GameService = require("sys/lua/src/services/game")

local json = require("sys/lua/libs/json")

function PlayerService:getPlayerStrategy(playerId)
    local strategy = {}
    if player(playerId,'usgn') > 0 then
        strategy['provider'] = 'usgn_id'
        strategy['value'] = player(playerId,'usgn')
    end
    if player(playerId,'steamid') ~= "0" then
        strategy['provider'] = 'steam_id'
        strategy['value'] = player(playerId,'steamid')
    end

    if strategy.provider == nil then
        parse('kick '..playerId..' You have to be logged on steam or with one usgn')
    end

    return strategy
end

function PlayerService:SelfMessage(playerId, message)
    msg2(playerId, message)
end

function PlayerService:RemoveWeapon(playerId, weaponId)
    parse('strip '..playerId..' '..weaponId)
end

function PlayerService:loadScoreBoard(playerId)
    local playerStrategy = PlayerService:getPlayerStrategy(playerId)
    local currentPlayer = PlayerRepository:findOne(playerStrategy)
    parse('setscore '..playerId..' '..currentPlayer.kills)
    parse('setdeaths '..playerId..' '..currentPlayer.deaths)
end

function PlayerService:onSpawn(playerId)
    local playerStrategy = PlayerService:getPlayerStrategy(playerId)
    local currentPlayer = PlayerRepository:findOne(playerStrategy)

    PlayerService:loadScoreBoard(playerId)
    PlayerService:Equip(playerId, currentPlayer.last_weapon_id)
end

function PlayerService:SetWeapon(playerId, weaponId)
    parse('setweapon '..playerId..' '..weaponId)
end

function PlayerService:Equip(playerId, weaponId)
    parse('equip '..playerId..' '..weaponId)
    PlayerService:SetWeapon(playerId, weaponId)
end

function PlayerService:onConnect(playerId)
    local playerStrategy = PlayerService:getPlayerStrategy(playerId)
    msg(json.encode(playerStrategy))

    local currentPlayer = PlayerRepository:findOne(playerStrategy)

    if currentPlayer.id == nil then
        PlayerRepository:save(playerStrategy)
        currentPlayer = PlayerRepository:findOne(playerStrategy)
    end

    msg(json.encode(currentPlayer))
end

function PlayerService:onKill(playerId)
    local playerStrategy = PlayerService:getPlayerStrategy(playerId)

    local currentPlayer = PlayerRepository:findOne(playerStrategy)

    if currentPlayer.exp < 10 then
        PlayerRepository:incrementExp(playerStrategy)
        PlayerService:SelfMessage(playerId, '+1 exp')
    else
        PlayerRepository:clearExp(playerStrategy)
        PlayerRepository:incrementLevel(playerStrategy)
        PlayerService:SelfMessage(playerId, 'You reached a new level now you are at '..currentPlayer.level + 1)
    end
    
    PlayerRepository:incrementKills(playerStrategy)

    PlayerService:RemoveWeapon(playerId, 50) -- Knife
    PlayerService:RemoveWeapon(playerId, player(playerId, 'weapontype'))

    local randomWeaponId = math.random(0, #GameService:loadWeaponsAvailable())
    
    PlayerService:Equip(playerId, GameService:loadWeaponsAvailable()[randomWeaponId])
    
    PlayerRepository:saveLastWeapon(playerStrategy, GameService:loadWeaponsAvailable()[randomWeaponId])
end

function PlayerService:onDie(playerId)
    local playerStrategy = PlayerService:getPlayerStrategy(playerId)
    local currentPlayer = PlayerRepository:findOne(playerStrategy)

    if currentPlayer.exp > 0 then
        PlayerRepository:decrementExp(playerStrategy)
        PlayerService:SelfMessage(playerId, '-1 exp')
    else
        if currentPlayer.level > 0 then
            PlayerRepository.decrementLevel(playerStrategy)
            PlayerService:SelfMessage(playerId, '-1 level')
        end
    end
 
    PlayerRepository:incrementDeaths(playerStrategy)
end

return PlayerService
