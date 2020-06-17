Config                            = {}
Config.DrawDistance               = 2.0
Config.MarkerType                 = 27
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true
Config.MaxInService               = 5
Config.Locale = 'en'
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.PoliceStations = {

  LSPD1 = {

    Blip = {
      Pos     = { x = 425.130, y = -979.558, z = 30.711 },
      Sprite  = 60,
      Display = 4,
      Scale   = 0.7,
      Colour  = 29,
    },

    AuthorizedWeapons = {
	  { name = 'WEAPON_FLASHLIGHT',         price = 80 },
	  { name = 'WEAPON_NIGHTSTICK',         price = 200 },
	  { name = 'WEAPON_STUNGUN',            price = 450 },
	  { name = 'WEAPON_COMBATPISTOL',       price = 450 },
    { name = 'WEAPON_FLARE',     		    price = 300 },
    { name = 'WEAPON_FLAREGUN',     	    price = 300 },
    { name = 'WEAPON_BZGAS',       	    price = 750 },
	  { name = 'WEAPON_PUMPSHOTGUN',        price = 600 },
    { name = 'WEAPON_ASSAULTSMG',         price = 1250 },
	  { name = 'WEAPON_SMG_MK2',     	    price = 1350 },
    { name = 'WEAPON_CARBINERIFLE',       price = 1500 },
	  { name = 'WEAPON_CARBINERIFLE_MK2',   price = 1700 },
	  { name = 'WEAPON_SPECIALCARBINE',     price = 1800 },
    { name = 'WEAPON_SNIPERRIFLE',        price = 1800 },
	  { name = 'WEAPON_HEAVYSNIPER',        price = 2500 },
	  { name = 'GADGET_PARACHUTE',          price = 1500 },
	},

	-- The Vehicles will be available by cop rank
	-- recruit = 0
	-- patrol = 1
	-- detective = 2
	-- sergeant = 3
	-- lieutenant = 4
	-- captain = 5
	-- boss = 6
    AuthorizedVehicles = {
      { name = 'scorcher',  	label = 'Fiets 			     [R:1]', rank = 0 },
      { name = 'police5',     label = 'Lamborghini Aventador     [R:4]', rank = 4 },
	  { name = 'fbi2',     label = 'Unmarked Volvo V70    [R:4]', rank = 4 },
	  { name = 'mercedesb', 	label = 'Mercedes B-classe  [R:3]', rank = 3 },
      { name = 'police', 	label = 'Volkswagen Touran  2017    [R:1]', rank = 1 },
	  { name = 'police3', 	label = 'Mercedes Sprinter    [R:1]', rank = 1 },
      { name = 'police2', 	label = 'Volkswagen Touran 2007  [R:1]', rank = 1 },
      { name = 'pa6', 	label = 'Snelweg Audi A6  [R:1]', rank = 1 },
      { name = 'policeb', 	label = 'Politie Motor   	 [R:2]', rank = 2 },
      { name = 'police4', 	label = 'Range Rover SVR    [R:3]', rank = 3 },
      { name = 'policeold1', 	label = 'Toyota Landcruiser [R:3]', rank = 3 },
      { name = 'policeold2', 	label = 'Volkswagen Busje     [R:4]', rank = 4 },
      { name = 'fbi', 	label = 'Audi RS6 Unmarked      [R:4]', rank = 4 },

    },

    Cloakrooms = {
      { x = 454.37, y = -991.24, z = 30.00 },
    },

    Armories = {
      { x = 451.699, y = -980.356, z = -129.689 },
    },

    Vehicles = {
      {
        Spawner    = { x = 454.69, y = -1017.4, z = -127.430 },
        SpawnPoint = { x = 438.42, y = -1018.3, z = -127.757 },
        Heading    = 90.0,
      }
    },

    Helicopters = {
      {
        Spawner    = { x = 466.477, y = -982.819, z = -142.691 },
        SpawnPoint = { x = 450.04, y = -981.14, z = -142.691 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = 462.74, y = -1014.4, z = -127.065 },
      { x = 462.40, y = -1019.7, z = -127.104 },
    },

    BossActions = {
      { x = 448.417, y = -973.208, z = -129.689 }
    },

  }

  

}
