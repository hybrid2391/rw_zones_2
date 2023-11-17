local state = "n"
local isMeldingVerstuurd = false 
local leaveMessage = 5000 
local isLeaveMessagePresent = false 
local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetEntityCoords(GetPlayerPed(-1))
        for zoneTitel, zoneData in pairs(Config.Neutralzones) do
        local playercoords = GetEntityCoords(PlayerPedId())
          if GetDistanceBetweenCoords(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, playercoords, false) < 250 then
          end
            if Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped) < zoneData.Radius then
            
                if isMeldingVerstuurd == false then
                    Wait(0)
                    isMeldingVerstuurd = true
                    EnteredRedzone()  
                end
            elseif Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped) < (zoneData.Radius + 30) and Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped) > zoneData.Radius then
                if isLeaveMessagePresent then
                end
                if isMeldingVerstuurd then
                    LeftRedzone() 
                end
                isMeldingVerstuurd = false
            end
        end
    end
end)

function EnteredRedzone()
    TriggerEvent('nneutral:on', true)
    isLeaveMessagePresent = true
end

function LeftRedzone()
    TriggerEvent("nneutral:off", true)
    Citizen.SetTimeout(leaveMessage, function() 
        isLeaveMessagePresent = false
    end)
end

RegisterNetEvent('nneutral:on')
AddEventHandler('nneutral:on', function()
    SendNUIMessage({
      type = "ui",
      state = "r"
    })
end)

RegisterNetEvent('nneutral:off')
AddEventHandler('nneutral:off', function()
    SendNUIMessage({
      type = "ui",
      state = "n"
    })
end)