local Framework = nil
K3 = {}
K3.Functions = {}

if Config.Framework == 'esx' then
    Framework = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qbcore' then
    Framework = exports["qb-core"]:GetCoreObject()
end

function K3.Functions.SpawnVehicle(carHash, coords, heading, plate, cb)
    local plate = plate or "K3"

    if Config.Framework == 'qbcore' then
        Framework.Functions.SpawnVehicle(carHash, function(vehicle)
            SetEntityHeading(vehicle, heading)
            SetVehicleNumberPlateText(vehicle, plate)
            cb(vehicle)
        end, coords, true)
    elseif Config.Framework == 'esx' then
        Framework.Game.SpawnVehicle(carHash, coords, heading, function(vehicle)
            SetEntityHeading(vehicle, heading)
            SetVehicleNumberPlateText(vehicle, plate)
            cb(vehicle)
        end)
    end
end

function K3.Functions.GetVehicleProperties (vehicle)
    if Config.Framework == 'qbcore' then
        local getProp = K3.Functions.GetVehicleProperties(vehicle)
        return getProp
    elseif Config.Framework == 'esx' then
        local getProp = Framework.Game.GetVehicleProperties(vehicle)
        return getProp
    end
end

function K3.Functions.TriggerCallback(...)
    if Config.Framework == 'qbcore' then
        Framework.Functions.TriggerCallback(...)
    elseif Config.Framework == 'esx' then
        Framework.TriggerServerCallback(...)
    end
end
