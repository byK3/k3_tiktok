
--[[
██████   █████  ████████  █████  ██████   █████  ███████ ███████ 
██   ██ ██   ██    ██    ██   ██ ██   ██ ██   ██ ██      ██      
██   ██ ███████    ██    ███████ ██████  ███████ ███████ █████   
██   ██ ██   ██    ██    ██   ██ ██   ██ ██   ██      ██ ██      
██████  ██   ██    ██    ██   ██ ██████  ██   ██ ███████ ███████                                                                                 
--]]

DB = {}

if Config.SQL == "oxmysql" then
    DB.execute = function(query, params, callback)
        exports.oxmysql:execute(query, params, function(result)
            if callback then callback(result.affectedRows) end
        end)
    end
    DB.fetchScalar = function(query, params, callback)
        exports.oxmysql:scalar(query, params, function(result)
            if callback then callback(result) end
        end)
    end
elseif Config.SQL == "mysql-async" then
    DB.execute = function(query, params, callback)
        MySQL.Async.execute(query, params, function(affectedRows)
            if callback then callback(affectedRows) end
        end)
    end
    DB.fetchScalar = function(query, params, callback)
        MySQL.Async.fetchScalar(query, params, function(scalar)
            if callback then callback(scalar) end
        end)
    end
elseif Config.SQL == "ghmattimysql" then
    DB.execute = function(query, params, callback)
        exports.ghmattimysql:execute(query, params, function(affectedRows)
            if callback then callback(affectedRows) end
        end)
    end
    DB.fetchScalar = function(query, params, callback)
        exports.ghmattimysql:scalar(query, params, function(scalar)
            if callback then callback(scalar) end
        end)
    end
end

local Framework = nil
K3 = {}
K3.Functions = {}

if Config.Framework == 'esx' then
    Framework = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qbcore' then
    Framework = exports["qb-core"]:GetCoreObject()
else
    print("^3[K3-ERROR]^0 Framework not found! - Please check your config.lua | Your Framework is set to: "..Config.Framework)
end

-- Framework Functions --
function K3.Functions.GetPlayer(src)
    if Config.Framework == "qbcore" then
        local xPlayer = Framework.Functions.GetPlayer(src)
        return xPlayer
    elseif Config.Framework == "esx" then
        local xPlayer = Framework.GetPlayerFromId(src)
        return xPlayer
    end
end

function K3.Functions.GetIdentifier (src)
    local xPlayer = K3.Functions.GetPlayer(src)
    if Config.Framework == "qbcore" then
        local identifier = xPlayer.PlayerData.citizenid
        return identifier
    elseif Config.Framework == "esx" then
        local identifier = xPlayer.identifier
        return identifier
    end
end

function K3.Functions.AddWeapon(src, weapon, ammo)
    local xPlayer = K3.Functions.GetPlayer(src)
    local weapon = weapon or "weapon_pistol"
    local ammo = ammo or 0

    if Config.Framework == "qbcore" then
        xPlayer.Functions.AddItem(weapon, ammo)
    elseif Config.Framework == "esx" then
        xPlayer.addWeapon(weapon, ammo)
    end
end

function K3.Functions.AddItem (src, item, amount)
    local xPlayer = K3.Functions.GetPlayer(src)
    local amount = amount or 1

    if Config.Framework == "qbcore" then
        xPlayer.Functions.AddItem(item, amount)
    elseif Config.Framework == "esx" then
        xPlayer.addInventoryItem(item, amount)
    end
end

function K3.Functions.AddMoney (src, money, amount)
    local xPlayer = K3.Functions.GetPlayer(src)
    local amount = amount or 1

    if Config.Framework == "qbcore" then
        xPlayer.Functions.AddMoney(money, amount)
    elseif Config.Framework == "esx" then
        if money == "cash" then
            money = "money"
        end
        xPlayer.addAccountMoney(money, amount)
    end
end 

function K3.Functions.RegisterServerCallback (...)
    if Config.Framework == "qbcore" then
        Framework.Functions.CreateCallback(...)
    elseif Config.Framework == "esx" then
        Framework.RegisterServerCallback(...)
    end
end

function K3.Functions.PlayerName (src)
    local xPlayer = K3.Functions.GetPlayer(src)
    if Config.Framework == "qbcore" then
        local name = xPlayer.PlayerData.charinfo.firstname.." "..xPlayer.PlayerData.charinfo.lastname
        return name
    elseif Config.Framework == "esx" then
        local name = xPlayer.getName()
        return name
    end
end

-- END Framework Functions --