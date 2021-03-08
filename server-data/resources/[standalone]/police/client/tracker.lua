RegisterNetEvent('police:client:CheckDistance')
AddEventHandler('police:client:CheckDistance', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("police:server:SetTracker", playerId)
    else
        QBCore.Functions.Notify("Ninguem por perto!", "error")
    end
end)

RegisterNetEvent('police:client:SetTracker')
AddEventHandler('police:client:SetTracker', function(bool)
    local trackerClothingData = {
        outfitData = {
            ["accessory"]   = { item = -1, texture = 0},  -- Nek / Das
        }
    }

    if bool then
        trackerClothingData.outfitData = {
            ["accessory"] = { item = 13, texture = 0}
        }

        TriggerEvent('qb-clothing:client:loadOutfit', trackerClothingData)
    else
        TriggerEvent('qb-clothing:client:loadOutfit', trackerClothingData)
    end
end)

RegisterNetEvent('police:client:SendTrackerLocation')
AddEventHandler('police:client:SendTrackerLocation', function(requestId)
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)

    TriggerServerEvent('police:server:SendTrackerLocation', coords, requestId)
end)

RegisterNetEvent('police:client:TrackerMessage')
AddEventHandler('police:client:TrackerMessage', function(msg, coords)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerEvent("chatMessage", "112-ALERTA", "error", msg)
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 458)
    SetBlipColour(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, transG)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Localização Pulseira Eletronica")
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)