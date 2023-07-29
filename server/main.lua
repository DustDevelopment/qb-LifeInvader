local QBCore = exports['qb-core']:GetCoreObject()
local MoneyType = Config.MoneyType
local lenpcsspawned = false

RegisterServerEvent("qb-lifeevader:gatherlenpc")
AddEventHandler("qb-lifeevader:gatherlenpc", function() 
    if lenpcsspawned == false then
		local _source = source
		TriggerClientEvent("qb-lifeevader:SpawnleGuards", _source)
		lenpcsspawned = true
	end
end)

RegisterNetEvent('qb-lifeevader:ResetGuardsle', function()
    if lenpcsspawned == true then
        lenpcsspawned = false
    end
end)

RegisterNetEvent('qb-lifeevader:leFinalDone', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(Config.HackItem, 1)
    Player.Functions.AddItem('Data_Usb', 1)
end)

RegisterNetEvent('qb-lifeevader:ReceivePaymentle', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local required = 'Data_Usb'
    local item = Config.leRewards[math.random(1, #Config.leRewards)]
    local amount = Config.leRewardAmount
    local chance = math.random(100)
    
    Player.Functions.RemoveItem(required, 1)
    Player.Functions.AddMoney(MoneyType, math.random(Config.PaymentleMin, Config.PaymentleMax))
    
    if chance<=Config.leItemChance then
        Player.Functions.AddItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
    end
end)
