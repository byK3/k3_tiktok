Config = {}


-- ░██████╗░███████╗███╗░░██╗███████╗██████╗░░█████╗░██╗░░░░░
-- ██╔════╝░██╔════╝████╗░██║██╔════╝██╔══██╗██╔══██╗██║░░░░░
-- ██║░░██╗░█████╗░░██╔██╗██║█████╗░░██████╔╝███████║██║░░░░░
-- ██║░░╚██╗██╔══╝░░██║╚████║██╔══╝░░██╔══██╗██╔══██║██║░░░░░
-- ╚██████╔╝███████╗██║░╚███║███████╗██║░░██║██║░░██║███████╗
-- ░╚═════╝░╚══════╝╚═╝░░╚══╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝

-- GENERAL --
Config.Language = 'en' -- default: en/de  || more options in language.lua
Config.Framework = 'esx' -- esx or qbcore
Config.SQL = 'mysql-async' -- oxmysql or mysql-async or ghmattimysql
Config.Debug = true -- enable debug mode true/false (will print debug messages in console)

-- COMMANDS --
Config.Command = "tiktok"
Config.databaseClearCommand = "cleardb" -- command to clear the database (only for admins)
Config.Groups = { -- This groups will be able to use the command cleardb command
    "admin",
}

-- REWARDS --
Config.Rewards = { -- Example for rewards
    {type = "item", name = "bread", amount = 10},
    {type = "item", name = "water", amount = 10},

    {type = "vehicle", category = "car", name = "adder", amount = 1}, -- category: car, boat, plane, helicopter

    {type = "weapon", name = "weapon_pistol", amount = 1},

    {type = "money", name = "cash", amount = 1000},
    {type = "money", name = "bank", amount = 1000},
    {type = "money", name = "black", amount = 1000},
}


-- ████████╗██████╗░██╗░██████╗░░██████╗░███████╗██████╗░░██████╗
-- ╚══██╔══╝██╔══██╗██║██╔════╝░██╔════╝░██╔════╝██╔══██╗██╔════╝
-- ░░░██║░░░██████╔╝██║██║░░██╗░██║░░██╗░█████╗░░██████╔╝╚█████╗░
-- ░░░██║░░░██╔══██╗██║██║░░╚██╗██║░░╚██╗██╔══╝░░██╔══██╗░╚═══██╗
-- ░░░██║░░░██║░░██║██║╚██████╔╝╚██████╔╝███████╗██║░░██║██████╔╝
-- ░░░╚═╝░░░╚═╝░░╚═╝╚═╝░╚═════╝░░╚═════╝░╚══════╝╚═╝░░╚═╝╚═════╝░

-- Change trigger events to your own framework or script (if you dont know what you are doing, dont touch this)

Config.vehicleSQL = {
    tableName = 'owned_vehicles',
    plateColumn = 'plate',
    ownerColumn = 'owner'
}

function clientNotify(message)
    if Config.Framework == 'esx' then
        TriggerEvent("esx:showNotification", message)
    elseif Config.Framework == 'qbcore' then
        TriggerEvent("QBCore:Notify", message)
    end
end

function serverNotify(source, message)
    if Config.Framework == 'esx' then
        TriggerClientEvent("esx:showNotification", source, message)
    elseif Config.Framework == 'qbcore' then
        TriggerClientEvent("QBCore:Notify", source, message)
    end
end

function debugger(message)
    if Config.Debug then
        local debugInfo = debug.getinfo(1)
        local debugString = "[^3" .. debugInfo.short_src .. "^0] - [^2DEBUG^0] - [^3".. debugInfo.currentline .. "^0] : " .. message
        print(debugString)
    end
end
