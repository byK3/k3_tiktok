-- ███████ ████████  █████  ██████  ████████ 
-- ██         ██    ██   ██ ██   ██    ██    
-- ███████    ██    ███████ ██████     ██    
--      ██    ██    ██   ██ ██   ██    ██    
-- ███████    ██    ██   ██ ██   ██    ██    

                                          
AddEventHandler('onResourceStart', function(resourceName)

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    print([[
    --------------------------------------------------
    ██   ██ ██████      ███████  ██████ ██████  ██ ██████  ████████ 
    ██  ██       ██     ██      ██      ██   ██ ██ ██   ██    ██    
    █████    █████      ███████ ██      ██████  ██ ██████     ██    
    ██  ██       ██          ██ ██      ██   ██ ██ ██         ██    
    ██   ██ ██████      ███████  ██████ ██   ██ ██ ██         ██    
                                                                    
    ----------------------------------
    Support Discord: byK3
    version: 1.0.0
    ]])

end)

local function generatePlate()
    return string.char(math.random(65, 90)) .. string.char(math.random(65, 90)) .. math.random(1000, 9999)
end

local function generateVehiclePlate(cb)
    local generatedPlate
    local count = 1

    local function checkPlate()
        DB.fetchScalar('SELECT COUNT(*) FROM '..Config.vehicleSQL.tableName..' WHERE '..Config.vehicleSQL.plateColumn..' = @plate', {
            ['@plate'] = generatedPlate
        }, function(c)
            count = c
            if count > 0 then
                generatedPlate = generatePlate()
                checkPlate()
            end
        end)
    end

    generatedPlate = generatePlate()
    checkPlate()

    cb(generatedPlate)
end

function GetVehicleReward(source, vehicleModel, vehicleType, vehiclePlate)
    local xPlayer = K3.Functions.GetPlayer(source)
    TriggerClientEvent('k3_spawnVehicleForData', xPlayer.source, vehicleModel, vehicleType, vehiclePlate)
end

K3.Functions.RegisterServerCallback('k3:saveVehicle', function(source, cb, vehicleProps, vehicleType)
    local xPlayer = K3.Functions.GetPlayer(source)
    local identifier = K3.Functions.GetIdentifier(source)
    
    local query = "INSERT INTO "..Config.vehicleSQL.tableName.." ("..Config.vehicleSQL.ownerColumn..", "..Config.vehicleSQL.plateColumn..", `vehicle`, `type`) VALUES (@owner, @plate, @vehicle, @type)"
    local params = {
        ['@owner'] = identifier,
        ['@plate'] = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps),
        ['@type'] = vehicleType
    }

    DB.execute(query, params, function(result)
        if result then
            cb(true)
        else
            debug ("[k3:saveVehicle] Error: Could not save vehicle!")
            cb(false)
        end
    end)
end)

RegisterCommand(Config.Command, function(source, args, rawCommand)
    local xPlayer = K3.Functions.GetPlayer(source)
    local identifier = K3.Functions.GetIdentifier(source)
    local xName = K3.Functions.PlayerName(source)
    if not xPlayer then return end

    local query = "SELECT * FROM `k3_tiktok` WHERE `player_identifier` = @identifier"
    local params = {['@identifier'] = identifier}
    DB.fetchScalar(query, params, function(result)
        if result then
            serverNotify(xPlayer.source, Translate('alreadyClaimed'))
        else
            local query = "INSERT INTO `k3_tiktok` (`player_identifier`) VALUES (@identifier)"
            local params = {['@identifier'] = identifier}
            DB.execute(query, params, function(result)
                if result then                    
                    for k,v in pairs(Config.Rewards) do
                        if v.type == "item" then
                            K3.Functions.AddItem(xPlayer.source, v.name, v.amount) 
                            debug ("[COMMAND] "..xName.." got x"..v.amount.." "..v.name.." !")
                            serverNotify(xPlayer.source, Translate('rewardItem', v.amount, v.name))           
                        elseif v.type == "weapon" then
                            K3.Functions.AddWeapon(xPlayer.source, v.name, v.amount)
                            serverNotify(xPlayer.source, Translate('rewardWeapon', v.name))
                        elseif v.type == "money" then
                            if v.name == "cash" then
                                K3.Functions.AddMoney(xPlayer.source, v.name, v.amount)
                                serverNotify(xPlayer.source, Translate('rewardMoney', v.amount))
                            elseif v.name == "bank" then
                                K3.Functions.AddMoney(xPlayer.source, v.name, v.amount)
                                serverNotify(xPlayer.source, Translate('rewardMoney', v.amount))
                            elseif v.name == "black" then
                                K3.Functions.AddMoney(xPlayer.source, "black_money", v.amount)
                                serverNotify(xPlayer.source, Translate('rewardMoney', v.amount))
                            end
                        elseif v.type == "vehicle" then
                            generateVehiclePlate(function(plate)
                                GetVehicleReward(xPlayer.source, v.name, v.category, plate)
                            end)
                        end
                    end
                    logToDiscord("TikTok Reward", "A player claimed his TikTok reward!", "green", "default", xPlayer)
                else
                    debug ("[COMMAND] Error: Unable to insert player into database! Indentifier: "..identifier)
                end
            end)
        end
    end)
end)

RegisterCommand("cleardb", function(source, args, rawCommand)
    local xPlayer = K3.Functions.GetPlayer(source)
    local identifier = K3.Functions.GetIdentifier(source)

    local query = "DELETE FROM `k3_tiktok` WHERE `player_identifier` = @identifier"
    local params = {['@identifier'] = identifier}
    DB.execute(query, params)
end)