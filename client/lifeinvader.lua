local QBCore = exports['qb-core']:GetCoreObject()
local GotJob = false
local Finished = true
local lecoords = vector3(-1082.73, -251.45, 37.76)
local leHacksDone = 0
local CurrentCops = 0
local HackingTime = Config.HackingTime*1000
local EmailTime = Config.EmailTime*1000
local npcspawned = false

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

Citizen.CreateThread(function()
    exports['qb-target']:SpawnPed({
        model = Config.leBossModel,
        coords = Config.leBossLocation, 
        minusOne = true, 
        freeze = true, 
        invincible = true, 
        blockevents = true,
        scenario = Config.leBossScenario,
        target = { 
            options = {
                {type = "client",event = "qb-lifeinvader:StartleDataBreach",icon = "fas fa-comment",label = "Start Lifeinvader Heist",},
                {type = "server",event = "qb-lifeinvader:ReceivePaymentle",icon = "fas fa-hand",label = "Receive Payment",item = "data_usb",},
            },
          distance = 2.5,
        },
    })
end)

RegisterNetEvent('qb-lifeinvader:StartleDataBreach', function()
    if GotJob == false then
        TriggerEvent('animations:client:EmoteCommandStart', {"wait"})
            QBCore.Functions.Progressbar('pickup', 'Getting Job...', 5000, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You will be emailed shortly with the location', 'primary')
                if CurrentCops >= Config.MinimumPolice then
                    Wait(EmailTime)
                    if Config.PhoneScript == 'qb' then
                        TriggerServerEvent('qb-phone:server:sendNewMail', {sender = "John Doe",subject = "Top Secret Documents...",
                            message = "Heres the location. you will need to hack each terminal in the office until you gain access to the locked pc. <br/> watch out for the guards. take friends with you and lots of guns!" ,
                        })
                    end
                    SetNewWaypoint(lecoords)
                    Exportle1Target()
                else
                    QBCore.Functions.Notify('Not enough police presence', 'error', 3000)
                end
            end)
        else
        QBCore.Functions.Notify('You Already Have a Job', 'error', 3000)
    end
end)

RegisterNetEvent('qb-lifeinvader:leHack1', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Hacking Computer', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                    TriggerServerEvent('police:server:policeAlert', 'Lifeinvader Heist In Progress')
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Rerouting Controls..', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                TriggerServerEvent('qb-lifeinvader:gatherlenpc')
                QBCore.Functions.Notify('Go To Another Computer, After Hacking 5 Computers go to the office and grab the data', 'primary', 8000)
                Wait(7500)
                leHacksDone = leHacksDone+1
                if leHacksDone < 5 then
                    Removele1Target()
                    Exportle1Target()
                elseif leHacksDone == 5 then
                    Removele1Target()
                    ExportleFinalTarget()
                end
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                if Config.PoliceAlertle then
                end
                TriggerServerEvent('qb-lifeinvader:gatherlenpc')
            end
        end, Config.leHackType, Config.leHackTime, 0)
    else
        QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
    end
end)

RegisterNetEvent('qb-lifeinvader:leHackFinal', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Braking Final Firewall...', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Downloading Top Secret Files..', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                TriggerServerEvent('qb-lifeinvader:leFinalDone')
                TriggerServerEvent('qb-lifeinvader:gatherlenpc')
                QBCore.Functions.Notify('You downloaded the file, now take it back!', 'primary', 8000)
                Wait(7500)
                RemoveleFinalTarget()
                leHacksDone = 0
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                TriggerServerEvent('qb-lifeinvader:gatherlenpc')
            end
        end, Config.leHackType, Config.leHackTime, 0)
    else
        QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
    end
end)

lesecurity = {
    ['lepatrol'] = {}
}

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

RegisterNetEvent('qb-lifeinvader:SpawnleGuards', function()
    SpawnGuardsle()
    TriggerServerEvent('qb-lifeinvader:ResetGuardsle')
end)

function SpawnGuardsle()
    local ped = PlayerPedId()
    local randomgun = Config.leGuardWeapon[math.random(1, #Config.leGuardWeapon)]

    SetPedRelationshipGroupHash(ped, `PLAYER`)
    AddRelationshipGroup('lepatrol')

    local numGuardsToSpawn = tonumber(Config['lesecurity'].NumGuardsToSpawn) -- Ensure NumGuardsToSpawn is a number

    if numGuardsToSpawn and numGuardsToSpawn > 0 then
        for i = 1, numGuardsToSpawn do
            local randomGuardIndex = math.random(1, #Config['lesecurity']['lepatrol'])
            local guardData = Config['lesecurity']['lepatrol'][randomGuardIndex]

            loadModel(guardData['model'])
            lesecurity['lepatrol'][randomGuardIndex] = CreatePed(26, GetHashKey(guardData['model']), guardData['coords'], guardData['heading'], true, true)
            NetworkRegisterEntityAsNetworked(lesecurity['lepatrol'][randomGuardIndex])
            networkID = NetworkGetNetworkIdFromEntity(lesecurity['lepatrol'][randomGuardIndex])
            SetNetworkIdCanMigrate(networkID, true)
            SetNetworkIdExistsOnAllMachines(networkID, true)
            SetPedRandomComponentVariation(lesecurity['lepatrol'][randomGuardIndex], 0)
            SetPedRandomProps(lesecurity['lepatrol'][randomGuardIndex])
            SetEntityAsMissionEntity(lesecurity['lepatrol'][randomGuardIndex])
            SetEntityVisible(lesecurity['lepatrol'][randomGuardIndex], true)
            SetPedRelationshipGroupHash(lesecurity['lepatrol'][randomGuardIndex], `lepatrol`)
            SetPedAccuracy(lesecurity['lepatrol'][randomGuardIndex], Config.leGuardAccuracy)
            SetPedArmour(lesecurity['lepatrol'][randomGuardIndex], 100)
            SetPedCanSwitchWeapon(lesecurity['lepatrol'][randomGuardIndex], true)
            SetPedDropsWeaponsWhenDead(lesecurity['lepatrol'][randomGuardIndex], false)
            SetPedFleeAttributes(lesecurity['lepatrol'][randomGuardIndex], 0, false)
            GiveWeaponToPed(lesecurity['lepatrol'][randomGuardIndex], randomgun, 999, false, false)
            TaskGoToEntity(lesecurity['lepatrol'][randomGuardIndex], PlayerPedId(), -1, 1.0, 10.0, 1073741824.0, 0)
            local random = math.random(1, 2)
            if random == 2 then
                TaskGuardCurrentPosition(lesecurity['lepatrol'][randomGuardIndex], 10.0, 10.0, 1)
            end
        end

        SetRelationshipBetweenGroups(0, `lepatrol`, `lepatrol`)
        SetRelationshipBetweenGroups(5, `lepatrol`, `PLAYER`)
        SetRelationshipBetweenGroups(5, `PLAYER`, `lepatrol`)
    else
        print("[ERROR] Invalid value for NumGuardsToSpawn in Config['lesecurity']. It must be a number greater than 0.")
    end
end
function Exportle1Target()
    if leHacksDone == 0 then
        leloc = vector3(-1063.42, -247.31, 44.02)
    elseif leHacksDone == 1 then
        leloc = vector3(-1062.88, -248.34, 44.02)
    elseif leHacksDone == 2 then
        leloc = vector3(-1061.11, -245.42, 44.02)
    elseif leHacksDone == 3 then
        leloc = vector3(-1059.68, -248.22, 44.02)
    elseif leHacksDone == 4 then
        leloc = vector3(-1060.18, -245.63, 44.02)
    end
    exports['qb-target']:AddBoxZone("le1-hack", leloc, 2, 2, {
        name="le1-hack",
        heading=90,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {type = "client",event = "qb-lifeinvader:leHack1",icon = "fas fa-shield",label = "Hack The Computer",item = Config.HackItem,},
        },
        distance = 2.0
    })
end


function ExportleFinalTarget()
    exports['qb-target']:AddBoxZone("lefinal", vector3(-1055.05, -232.82, 44.02), 1, 1, {
        name="lefinal",
        heading=173,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {type = "client",event = "qb-lifeinvader:leHackFinal",icon = "fas fa-hand",label = "Extract Files",item = Config.HackItem,},
        },
        distance = 2.0
    })
end

function Removele1Target()
    exports['qb-target']:RemoveZone("le1-hack")
end

function RemoveleFinalTarget()
    exports['qb-target']:RemoveZone("lefinal")
end
