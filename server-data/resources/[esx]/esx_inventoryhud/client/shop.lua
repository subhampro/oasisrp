local shopData
ESX = nil
local Licenses = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1)
        coords = GetEntityCoords(player)
        if IsInRegularShopZone(coords) or IsInRobsLiquorZone(coords) or IsInYouToolZone(coords) or IsInPrisonShopZone(coords) or IsInWeaponShopZone(coords) then
            if IsInRegularShopZone(coords) then
                if IsControlJustReleased(0, 38) then
                    OpenShopInv("regular")
                    TriggerScreenblurFadeIn(0)
                    Citizen.Wait(2000)
                end
            end
            if IsInRobsLiquorZone(coords) then
                if IsControlJustReleased(0, 38) then
                    OpenShopInv("robsliquor")
                    TriggerScreenblurFadeIn(0)
                    Citizen.Wait(2000)
                end
            end
            if IsInYouToolZone(coords) then
                if IsControlJustReleased(0, 38) then
                    OpenShopInv("youtool")
                    TriggerScreenblurFadeIn(0)
                    Citizen.Wait(2000)
                end
            end
            if IsInPrisonShopZone(coords) then
                if IsControlJustReleased(0, 38) then
                    OpenShopInv("prison")
                    TriggerScreenblurFadeIn(0)
                    Citizen.Wait(2000)
                end
            end
            if IsInWeaponShopZone(coords) then
                if IsControlJustReleased(0, 38) then
                    if Licenses['weapon'] ~= nil then
                        OpenShopInv("weaponshop")
                        TriggerScreenblurFadeIn(0)
                        Citizen.Wait(2000)
                    else
                        exports['mythic_notify']:SendAlert('error', 'You need a Fire Arms license before you can buy weapons')
                    end
                end
            end
        end
    end
end)

function OpenShopInv(shoptype)
    text = "shop"
    data = {text = text}
    inventory = {}

    ESX.TriggerServerCallback("suku:getShopItems", function(shopInv)
        for i = 1, #shopInv, 1 do
            table.insert(inventory, shopInv[i])
        end
    end, shoptype)

    Citizen.Wait(500)
    TriggerEvent("esx_inventoryhud:openShopInventory", data, inventory)
end

RegisterNetEvent("suku:OpenCustomShopInventory")
AddEventHandler("suku:OpenCustomShopInventory", function(type, shopinventory)
    text = "shop"
    data = {text = text}
    inventory = {}

    ESX.TriggerServerCallback("suku:getCustomShopItems", function(shopInv)
        for i = 1, #shopInv, 1 do
            table.insert(inventory, shopInv[i])
        end
    end, type, shopinventory)
    Citizen.Wait(500)

    TriggerEvent("esx_inventoryhud:openShopInventory", data, inventory)
end)

RegisterNetEvent("esx_inventoryhud:openShopInventory")
AddEventHandler("esx_inventoryhud:openShopInventory", function(data, inventory)
	setShopInventoryData(data, inventory, weapons)
	openShopInventory()
end)

function setShopInventoryData(data, inventory)
    shopData = data

    SendNUIMessage({action = "setInfoText", text = data.text})

    items = {}

    SendNUIMessage({action = "setShopInventoryItems", itemList = inventory})
end

function openShopInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage({action = "display", type = "shop"})

    SetNuiFocus(true, true)
end

RegisterNUICallback("TakeFromShop", function(data, cb)
	if IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	if type(data.number) == "number" and math.floor(data.number) == data.number then
		TriggerServerEvent("suku:SellItemToPlayer", GetPlayerServerId(PlayerId()), data.item.type, data.item.name, tonumber(data.number))
	end

        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end)

RegisterNetEvent("suku:AddAmmoToWeapon")
AddEventHandler("suku:AddAmmoToWeapon", function(hash, amount)
    AddAmmoToPed(GetPlayerPed(-1), hash, amount)
end)

function IsInRegularShopZone(coords)
    RegularShop = Config.Shops.RegularShop.Locations
    for i = 1, #RegularShop, 1 do
        if GetDistanceBetweenCoords(coords, RegularShop[i].x, RegularShop[i].y, RegularShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInRobsLiquorZone(coords)
    RobsLiquor = Config.Shops.RobsLiquor.Locations
    for i = 1, #RobsLiquor, 1 do
        if GetDistanceBetweenCoords(coords, RobsLiquor[i].x, RobsLiquor[i].y, RobsLiquor[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInYouToolZone(coords)
    YouTool = Config.Shops.YouTool.Locations
    for i = 1, #YouTool, 1 do
        if GetDistanceBetweenCoords(coords, YouTool[i].x, YouTool[i].y, YouTool[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInPrisonShopZone(coords)
    PrisonShop = Config.Shops.PrisonShop.Locations
    for i = 1, #PrisonShop, 1 do
        if GetDistanceBetweenCoords(coords, PrisonShop[i].x, PrisonShop[i].y, PrisonShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInWeaponShopZone(coords)
    WeaponShop = Config.Shops.WeaponShop.Locations
    for i = 1, #WeaponShop, 1 do
        if GetDistanceBetweenCoords(coords, WeaponShop[i].x, WeaponShop[i].y, WeaponShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1)
        coords = GetEntityCoords(player)

        if GetDistanceBetweenCoords(coords, Config.WeaponLiscence.x, Config.WeaponLiscence.y, Config.WeaponLiscence.z, true) < 3.0 then
            ESX.Game.Utils.DrawText3D(vector3(Config.WeaponLiscence.x, Config.WeaponLiscence.y, Config.WeaponLiscence.z), "Press ~r~[E]~s~ to open shop", 0.6)

            if IsControlJustReleased(0, 38) then
                if Licenses['weapon'] == nil then
                    OpenBuyLicenseMenu()
                else
                    exports['mythic_notify']:SendAlert('error', 'You already have a Fire arms license!')
                end
                Citizen.Wait(2000)
            end
        end
    end
end)

RegisterNetEvent('suku:GetLicenses')
AddEventHandler('suku:GetLicenses', function (licenses)
    for i = 1, #licenses, 1 do
        Licenses[licenses[i].type] = true
    end
end)

function OpenBuyLicenseMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_license',{
        title = 'Register a License?',
        elements = {
          {label = 'yes' ..' ($' .. Config.LicensePrice ..')', value = 'yes'},
          {label = 'no', value = 'no' },
     }}, function (data, menu)
        if data.current.value == 'yes' then
            TriggerServerEvent('suku:buyLicense')
        end
        menu.close()
    end, function (data, menu)
        menu.close()
    end)
end

Citizen.CreateThread(function()
    player = GetPlayerPed(-1)
    coords = GetEntityCoords(player)
    for k, v in pairs(Config.Shops.RegularShop.Locations) do
        CreateBlip(vector3(Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z ), "Convenience Store", 3.0, Config.Color, Config.ShopBlipID)
    end

    for k, v in pairs(Config.Shops.RobsLiquor.Locations) do
        CreateBlip(vector3(Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z ), "RobsLiquor", 3.0, Config.Color, Config.LiquorBlipID)
    end

    for k, v in pairs(Config.Shops.YouTool.Locations) do
        CreateBlip(vector3(Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z ), "YouTool", 3.0, Config.Color, Config.YouToolBlipID)
    end

    for k, v in pairs(Config.Shops.YouTool.Locations) do
        CreateBlip(vector3(Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z), "Prison Commissary", 3.0, Config.Color, Config.PrisonShopBlipID)
    end

    for k, v in pairs(Config.Shops.WeaponShop.Locations) do
        CreateBlip(vector3(Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z), "Ammunation", 3.0, Config.WeaponColor, Config.WeaponShopBlipID)
    end

    CreateBlip(vector3(-755.79, 5596.07, 41.67), "Cablecart", 3.0, 4, 36)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1)
        coords = GetEntityCoords(player)

        for k, v in pairs(Config.Shops.RegularShop.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z, true) < 3.0 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z + 1.0), "Press ~r~[E]~s~ to open shop", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.RobsLiquor.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z, true) < 3.0 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z + 1.0), "Press ~r~[E]~s~ to open shop", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.YouTool.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z, true) < 3.0 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z + 1.0), "Press ~r~[E]~s~ to open shop", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.PrisonShop.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z, true) < 3.0 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z), "Press ~r~[E]~s~ to open shop", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.WeaponShop.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z, true) < 3.0 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z + 1.0), "Press ~r~[E]~s~ to open shop", 0.6)
            end
        end
    end
end)

function CreateBlip(coords, text, radius, color, sprite)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, color)
	SetBlipScale(blip, 0.6)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end
