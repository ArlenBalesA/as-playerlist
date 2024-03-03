local playerList = {}
local disconnectedPlayers = {}
local RSGCore = exports['rsg-core']:GetCoreObject()
AS = {}

RegisterCommand("playerlist",function()
    TriggerEvent('as-playerlist:client:manualUpdate')
    Wait(500)
    if playerList then 
        SendNUIMessage({
            type = "OPEN",
            data = {
                activePlayers = playerList,
                disconnectedPlayers = disconnectedPlayers
            }
        })
        SetNuiFocus(1,1)
        print(json.encode(playerList))
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlPressed(0, RSGCore.Shared.Keybinds['DEL']) then
            TriggerEvent('as-playerlist:client:manualUpdate')
            Wait(500)
            if playerList then 
                SendNUIMessage({
                    type = "OPEN",
                    data = {
                        activePlayers = playerList,
                        disconnectedPlayers = disconnectedPlayers
                    }
                })
                SetNuiFocus(1,1)
                print(json.encode(playerList))
            end
        end
    end
end)

RegisterNetEvent('as-playerlist:client:manualUpdate')
AddEventHandler('as-playerlist:client:manualUpdate', function(activePlayers,disPlayers)
    TriggerServerEvent('as-playerlist:server:manualUpdate')
    playerList = activePlayers
    disconnectedPlayers = disPlayers
end)

RegisterNUICallback("getData", function(data,cb)
    if data.variable == "online" then
        cb(playerList)
    else
        cb(disconnectedPlayers)
    end
end)


RegisterNUICallback("close",function()
    SetNuiFocus(0,0)
end)