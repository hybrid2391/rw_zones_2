local state = "g"
local isMeldingVerstuurd = false 
local leaveMessage = 5000 
local isLeaveMessagePresent = false
local speedInGZ = Config.speedgreenzone
local speedNotInGZ = 9000.0 
local isInCityZone = false 
local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isInCityZone and Config.speedlimiter then
        	SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),speedInGZ)
        else
        	SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),speedNotInGZ)
        end
        local ped = GetEntityCoords(GetPlayerPed(-1))
        for zoneTitel, zoneData in pairs(Config.Greenzones) do
            if Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped) < zoneData.Radius then
                DisableActions() 
                if isLeaveMessagePresent then
                end
                if isMeldingVerstuurd == false then 
                    Wait(0)
                    isMeldingVerstuurd = true
                    EnteredGreenzone()  
                end
            elseif Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped) < (zoneData.Radius + 30) and Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped) > zoneData.Radius then
                if isLeaveMessagePresent then
                end
                if isMeldingVerstuurd then
                    LeftGreenzone() 
                end
                isMeldingVerstuurd = false
            end
        end
    end
end)

function EnteredGreenzone()
    TriggerEvent('ggreen:on', true)
    isLeaveMessagePresent = true
    Citizen.SetTimeout(leaveMessage, function() 
        isLeaveMessagePresent = false
    end)
    isInCityZone = true
end

function LeftGreenzone()
    TriggerEvent("ggreen:off", true)
    SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),speedNotInGZ)
    isLeaveMessagePresent = true
    Citizen.SetTimeout(leaveMessage, function() 
        isLeaveMessagePresent = false
    end)
    isInCityZone = false
end

function DisableActions()
    local player = QBCore.Functions.GetPlayerData()

    if player.job.name ~= "police" and Config.disablefireongreenzone then
        local controlActions = {
            {0, 45},
            {0, 24},
            {0, 263},
            {0, 140},
            {0, 142},
            {2, 37}
        }

        for _, action in ipairs(controlActions) do
            DisableControlAction(action[1], action[2], true)
        end

        DisablePlayerFiring(GetPlayerPed(-1), true)
        SetPlayerInvincible(PlayerId(), true)
    else
        for _, v in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(v)
            SetEntityNoCollisionEntity(GetPlayerPed(-1), GetVehiclePedIsIn(ped, false), true)
            SetEntityNoCollisionEntity(GetVehiclePedIsIn(ped, false), GetVehiclePedIsIn(GetPlayerPed(-1), false), true)
        end
    end
end

RegisterNetEvent('ggreen:on')
AddEventHandler('ggreen:on', function()
    SendNUIMessage({
      type = "ui",
      state = "g"
    })
end)

RegisterNetEvent('ggreen:off')
AddEventHandler('ggreen:off', function()
    SendNUIMessage({
      type = "ui",
      state = "n"
    })
end)