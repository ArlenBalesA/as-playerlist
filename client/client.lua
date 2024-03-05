local playerList = {}
local disconnectedPlayers = {}
local disPlayerNames = 10
local playerDistances = {}
local showIDsAboveHead = false
AS = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlPressed(0, 0x4AF4D473) then
            TriggerEvent('as-playerlist:client:getPlayers')
            showIDsAboveHead = true
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
                SetNuiFocusKeepInput(true)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for id = 0, 255 do
                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                playerDistances[id] = distance
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if showIDsAboveHead then
            for id = 0, 255 do 
                if NetworkIsPlayerActive(id) then
                        if (playerDistances[id] < disPlayerNames) then
                            x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                            if NetworkIsPlayerTalking(id) then
                                DrawText3D(x2, y2, z2+1, GetPlayerServerId(id), 247,124,24)
                            else
                                DrawText3D(x2, y2, z2+1, GetPlayerServerId(id), 255,255,255)
                            end
                        end  
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function DrawText3D(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end


RegisterNetEvent('as-playerlist:client:getPlayers')
AddEventHandler('as-playerlist:client:getPlayers', function(activePlayers,disPlayers)
    TriggerServerEvent('as-playerlist:server:getPlayers')
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
    showIDsAboveHead = false
end)