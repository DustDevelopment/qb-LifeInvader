Config = {}


Config.PhoneScript = 'qb'


Config.DebugHeists = false -- true for testing
Config.DebugPoly = true
Config.AddEndJobCommand = true --adds slash commands to end a job if someone gets bugged out

Config.MinimumPolice = 0 --change this to whatever you like
Config.PoliceAlertle = true
Config.MoneyType = 'cash'  -- cash/bank/blackmoney   -- whatever your server uses
Config.EmailTime = 30 --how many seconds after accepting job before you ge the email for it

--====Hack stuff====--

Config.HackItem = 'electronickit' -- item used to hack things you are free to change it to whatever you want
Config.leHackType = 'alphabet'
Config.leHackTime = 30
Config.HackingTime = 1 --how long for hacking progressbars
Config.leBossModel = 'g_f_y_vagos_01'
Config.leBossLocation = vector4(711.1, -2264.1, 27.53, 39.44)
Config.leBossScenario = 'WORLD_HUMAN_SMOKING'
Config.PaymentleMin = 200
Config.PaymentleMax = 300
Config.leItemChance = 5 --in % chance of getting random item from below
Config.leRewards = {
    'usb4', 
    'usb3',
    'usb2',
}
Config.leRewardAmount = 2

--====le GUARDS====--
Config.leGuardAccuracy = 70
Config.leGuardWeapon = { --this must be the weapon hash not just the weapon item name --this randomises between different guns everytime the guards are spawned
`WEAPON_HEAVYPISTOL`,
}

Config['lesecurity'] = {
    ['lepatrol'] = {
        { coords = vector3(-1076.09, -243.62, 44.02), heading = 308.78, model = 'csb_prolsec'},
        { coords = vector3(-1072.59, -248.8, 44.02), heading = 204.11, model = 'csb_prolsec'},
    },
}


