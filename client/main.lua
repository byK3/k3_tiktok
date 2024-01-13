RegisterNetEvent('k3_spawnVehicleForData')
AddEventHandler('k3_spawnVehicleForData', function(vehicleModel, vehicleType, vehiclePlate)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local carHash = GetHashKey(vehicleModel)

    K3.Functions.SpawnVehicle(vehicleModel, coords, GetEntityHeading(playerPed), vehiclePlate, function(vehicle)
        local vehicleProps = K3.Functions.GetVehicleProperties(vehicle)

        K3.Functions.TriggerCallback('k3:saveVehicle', function(result)
            if result then
                clientNotify(Translate('rewardVehicle', vehicleModel))
            else
                clientNotify(Translate('error'))
            end
        end, vehicleProps, vehicleType)

        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end)
end)