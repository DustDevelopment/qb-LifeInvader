local QBCore = exports['qb-core']:GetCoreObject()
local GotJob = false
local Finished = true
local GotJobA = false
local GotJobB = false
local GotJobC = false
local carmodel = nil
local location = nil
local lecoords = vector3(-1082.73, -251.45, 37.76)
local leHacksDone = 0
local CurrentCops = 0
local SecurityBypass = false
local HackingTime = Config.HackingTime*1000
local EmailTime = Config.EmailTime*1000
local npcspawned = false

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('qb-lifeinvader:EndHeistCommand', function()
    GotJob = false
    Finished = true
    GotJobA = false
    GotJobB = false
    GotJobC = false
    carmodel = nil
    location = nil
    SecurityBypass = false
    QBCore.Functions.Notify('All Heist Parameters Reset', 'success', 2000)
    if Config.DebugHeists then
        print("GotJob "..GotJob)
        print("Finished "..Finished)
        print("GotJobA "..GotJobA)
        print("GotJobB "..GotJobB)
        print("GotJobC "..GotJobC)
        print("carmodel "..carmodel)
        print("location "..location)
        print("SecurityBypass "..SecurityBypass)
    end
end)

